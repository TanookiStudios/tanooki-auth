#include "flutter_window.h"

#include <optional>
#include <string>
#include <vector>

#include <flutter/standard_method_codec.h>

#include "flutter/generated_plugin_registrant.h"
#include "resource.h"

namespace {
constexpr UINT kTrayMessage = WM_APP + 1;
}

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());

  window_channel_ = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      flutter_controller_->engine()->messenger(), "tanooki/window",
      &flutter::StandardMethodCodec::GetInstance());
  window_channel_->SetMethodCallHandler([this](const auto& call, auto result) {
    HWND hwnd = GetHandle();
    if (call.method_name() == "focus") {
      if (IsIconic(hwnd)) ShowWindow(hwnd, SW_RESTORE);
      // Windows may refuse focus stealing; then the taskbar button flashes instead.
      if (!SetForegroundWindow(hwnd)) FlashWindow(hwnd, TRUE);
      result->Success();
    } else if (call.method_name() == "setSecure") {
      // Leaves the window out of screenshots, screen recording and screen sharing.
      const auto* on = std::get_if<bool>(call.arguments());
      secure_ = on != nullptr && *on;
      SetWindowDisplayAffinity(hwnd, secure_ ? WDA_EXCLUDEFROMCAPTURE : WDA_NONE);
      result->Success();
    } else if (call.method_name() == "captureScreen") {
      // GDI picture of the whole desktop (all monitors), leaving out our own window.
      SetWindowDisplayAffinity(hwnd, WDA_EXCLUDEFROMCAPTURE);
      const int x = GetSystemMetrics(SM_XVIRTUALSCREEN), y = GetSystemMetrics(SM_YVIRTUALSCREEN);
      const int w = GetSystemMetrics(SM_CXVIRTUALSCREEN), h = GetSystemMetrics(SM_CYVIRTUALSCREEN);
      HDC screen = GetDC(nullptr);
      HDC mem = CreateCompatibleDC(screen);
      BITMAPINFO bmi = {};
      bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
      bmi.bmiHeader.biWidth = w;
      bmi.bmiHeader.biHeight = -h;  // top-down rows
      bmi.bmiHeader.biPlanes = 1;
      bmi.bmiHeader.biBitCount = 32;
      bmi.bmiHeader.biCompression = BI_RGB;
      void* bits = nullptr;
      HBITMAP bmp = CreateDIBSection(screen, &bmi, DIB_RGB_COLORS, &bits, nullptr, 0);
      bool ok = false;
      std::vector<uint8_t> pixels;
      if (bmp && bits) {
        HGDIOBJ old = SelectObject(mem, bmp);
        ok = BitBlt(mem, 0, 0, w, h, screen, x, y, SRCCOPY | CAPTUREBLT) != 0;
        if (ok) pixels.assign(static_cast<uint8_t*>(bits), static_cast<uint8_t*>(bits) + static_cast<size_t>(w) * h * 4);
        SelectObject(mem, old);
        DeleteObject(bmp);
      }
      DeleteDC(mem);
      ReleaseDC(nullptr, screen);
      SetWindowDisplayAffinity(hwnd, secure_ ? WDA_EXCLUDEFROMCAPTURE : WDA_NONE);
      if (!ok) {
        result->Error("failed", "Screen capture failed");
        return;
      }
      flutter::EncodableMap shot{
          {flutter::EncodableValue("width"), flutter::EncodableValue(w)},
          {flutter::EncodableValue("height"), flutter::EncodableValue(h)},
          {flutter::EncodableValue("bgra"), flutter::EncodableValue(std::move(pixels))},
      };
      result->Success(flutter::EncodableValue(flutter::EncodableList{flutter::EncodableValue(shot)}));
    } else if (call.method_name() == "typeText") {
      // Types the code into the window that was in front before ours, as if typed on the keyboard.
      const auto* text = std::get_if<std::string>(call.arguments());
      if (text == nullptr || text->empty()) {
        result->Error("failed", "Nothing to type");
        return;
      }
      ShowWindow(hwnd, SW_MINIMIZE);  // hands focus back to the window you were in
      Sleep(300);
      HWND front = GetForegroundWindow();
      DWORD pid = 0;
      if (front != nullptr) GetWindowThreadProcessId(front, &pid);
      if (front == nullptr || pid == GetCurrentProcessId()) {
        // Never type into Tanooki Auth itself.
        ShowWindow(hwnd, SW_RESTORE);
        SetForegroundWindow(hwnd);
        result->Error("self");
        return;
      }
      const int len = MultiByteToWideChar(CP_UTF8, 0, text->c_str(), -1, nullptr, 0);
      std::wstring wide(len > 0 ? len - 1 : 0, L'\0');
      if (len > 1) MultiByteToWideChar(CP_UTF8, 0, text->c_str(), -1, wide.data(), len);
      std::vector<INPUT> keys;
      for (wchar_t c : wide) {
        INPUT down = {};
        down.type = INPUT_KEYBOARD;
        down.ki.wScan = c;
        down.ki.dwFlags = KEYEVENTF_UNICODE;
        INPUT up = down;
        up.ki.dwFlags |= KEYEVENTF_KEYUP;
        keys.push_back(down);
        keys.push_back(up);
      }
      const UINT sent = SendInput(static_cast<UINT>(keys.size()), keys.data(), sizeof(INPUT));
      if (sent != keys.size()) {
        result->Error("failed", "Windows blocked the key presses");
        return;
      }
      result->Success();
    } else {
      result->NotImplemented();
    }
  });

  tray_.cbSize = sizeof(tray_);
  tray_.hWnd = GetHandle();
  tray_.uID = 1;
  tray_.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
  tray_.uCallbackMessage = kTrayMessage;
  tray_.hIcon = LoadIcon(GetModuleHandle(nullptr), MAKEINTRESOURCE(IDI_APP_ICON));
  wcscpy_s(tray_.szTip, L"Tanooki Auth");
  Shell_NotifyIcon(NIM_ADD, &tray_);
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  // Flutter can complete the first frame before the "show window" callback is
  // registered. The following call ensures a frame is pending to ensure the
  // window is shown. It is a no-op if the first frame hasn't completed yet.
  flutter_controller_->ForceRedraw();

  return true;
}

void FlutterWindow::OnDestroy() {
  Shell_NotifyIcon(NIM_DELETE, &tray_);
  window_channel_ = nullptr;
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
    case kTrayMessage:
      if (LOWORD(lparam) == WM_LBUTTONUP || LOWORD(lparam) == WM_RBUTTONUP) {
        if (IsIconic(hwnd)) ShowWindow(hwnd, SW_RESTORE);
        ShowWindow(hwnd, SW_SHOW);
        SetForegroundWindow(hwnd);
        if (window_channel_) window_channel_->InvokeMethod("trayClicked", nullptr);
      }
      return 0;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
