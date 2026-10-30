#ifndef RUNNER_SECURITY_KEY_H_
#define RUNNER_SECURITY_KEY_H_

#include <flutter/encodable_value.h>
#include <flutter/method_call.h>
#include <flutter/method_result.h>
#include <windows.h>

#include <functional>
#include <memory>

// Handles one call on the tanooki/securitykey channel (security_key.cpp). Long-running calls finish on a worker
// thread and hand their result to [on_platform_thread], which must run it on the platform thread.
void HandleSecurityKey(const flutter::MethodCall<flutter::EncodableValue>& call,
                       std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result, HWND hwnd,
                       std::function<void(std::function<void()>)> on_platform_thread);

#endif  // RUNNER_SECURITY_KEY_H_
