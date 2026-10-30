import {
  Action,
  ActionPanel,
  Clipboard,
  Form,
  Icon,
  List,
  Toast,
  closeMainWindow,
  open,
  showHUD,
  showToast,
  useNavigation,
} from "@raycast/api";
import { useCallback, useEffect, useState } from "react";
import { createClient, groupCode, type AccountWithCode, type BridgeError } from "../../shared/bridge.mjs";

const bridge = createClient("raycast", "Raycast");

export default function SearchCodes() {
  const [accounts, setAccounts] = useState<AccountWithCode[]>();
  const [error, setError] = useState<BridgeError>();
  const [now, setNow] = useState(Date.now());

  const load = useCallback(async () => {
    try {
      setAccounts(await bridge.listCodes());
      setError(undefined);
    } catch (e) {
      setError(e as BridgeError);
    }
  }, []);

  useEffect(() => {
    load();
  }, [load]);

  // Tick the countdowns; fetch again once any code has expired (or to retry after an error).
  useEffect(() => {
    const timer = setInterval(() => setNow(Date.now()), 1000);
    return () => clearInterval(timer);
  }, []);
  useEffect(() => {
    if (error ? now % 3000 < 1000 : accounts?.some((a) => a.expiresAt != null && a.expiresAt <= now)) load();
  }, [now]);

  if (error) return <ErrorView error={error} onRetry={load} />;

  return (
    <List isLoading={!accounts} searchBarPlaceholder="Search accounts…">
      {accounts?.length === 0 && <List.EmptyView title="No accounts in Tanooki Auth yet" description="Add accounts in the Tanooki Auth app." />}
      {accounts?.map((a) => (
        <List.Item
          key={a.id}
          icon={Icon.Key}
          title={a.issuer || a.label}
          subtitle={a.issuer ? a.label : undefined}
          keywords={[a.label, ...a.domains]}
          accessories={
            a.code && a.expiresAt
              ? [{ text: groupCode(a.code) }, { text: `${Math.max(0, Math.ceil((a.expiresAt - now) / 1000))}s` }]
              : [{ text: "Counter-based", tooltip: "Each code works once, so a new one is made when you copy or paste" }]
          }
          actions={
            <ActionPanel>
              <Action title="Copy Code" icon={Icon.Clipboard} onAction={() => deliver(a, "copy")} />
              <Action title="Paste Code" icon={Icon.Text} onAction={() => deliver(a, "paste")} />
              <Action title="Refresh" icon={Icon.ArrowClockwise} shortcut={{ modifiers: ["cmd"], key: "r" }} onAction={load} />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}

// Always asks the app for the code at the moment of use, so a code about to expire is never handed over.
async function deliver(a: AccountWithCode, how: "copy" | "paste") {
  let code: string;
  try {
    ({ code } = await bridge.code(a.id));
  } catch (e) {
    await showToast({ style: Toast.Style.Failure, title: "Couldn't get the code", message: (e as Error).message });
    return;
  }
  if (how === "copy") {
    await Clipboard.copy(code, { concealed: true });
    await showHUD(`Copied ${a.issuer || a.label} code`);
  } else {
    await closeMainWindow();
    await Clipboard.paste(code);
  }
}

function ErrorView({ error, onRetry }: { error: BridgeError; onRetry: () => void }) {
  const retry = <Action title="Try Again" icon={Icon.ArrowClockwise} onAction={onRetry} />;
  if (error.code === "notPaired") {
    return (
      <List>
        <List.EmptyView
          icon={Icon.Link}
          title="Pair with Tanooki Auth"
          description="Connect Raycast to the Tanooki Auth app on this Mac. You only do this once. Press Enter to start."
          actions={
            <ActionPanel>
              <Action.Push title="Start Pairing" icon={Icon.Link} target={<PairForm onPaired={onRetry} />} />
              {retry}
            </ActionPanel>
          }
        />
      </List>
    );
  }
  const title = error.code === "noApp" ? "Open Tanooki Auth" : error.code === "locked" ? "Unlock Tanooki Auth" : "Tanooki Auth";
  return (
    <List>
      <List.EmptyView
        icon={Icon.Lock}
        title={title}
        description={error.message}
        actions={
          <ActionPanel>
            {(error.code === "noApp" || error.code === "locked") && (
              <Action title="Open Tanooki Auth" icon={Icon.AppWindow} onAction={() => open("Tanooki Auth")} />
            )}
            {retry}
          </ActionPanel>
        }
      />
    </List>
  );
}

function PairForm({ onPaired }: { onPaired: () => void }) {
  const { pop } = useNavigation();
  const [started, setStarted] = useState(false);
  const [codeError, setCodeError] = useState<string>();

  const start = useCallback(async () => {
    setStarted(false);
    try {
      await bridge.pairStart();
      setStarted(true);
    } catch (e) {
      await showToast({ style: Toast.Style.Failure, title: "Couldn't start pairing", message: (e as Error).message });
    }
  }, []);

  useEffect(() => {
    start();
  }, [start]);

  async function submit({ code }: { code: string }) {
    try {
      await bridge.pairFinish(code);
    } catch (e) {
      const err = e as BridgeError;
      setCodeError(err.message);
      // Three wrong codes or a closed dialog end the attempt; ask the app for a new code.
      if (err.code === "pairing") await start();
      return;
    }
    await showToast({ style: Toast.Style.Success, title: "Raycast is paired with Tanooki Auth" });
    onPaired();
    pop();
  }

  return (
    <Form
      isLoading={!started}
      actions={
        <ActionPanel>
          <Action.SubmitForm title="Pair" icon={Icon.Link} onSubmit={submit} />
          <Action title="Show a New Code" icon={Icon.ArrowClockwise} onAction={start} />
        </ActionPanel>
      }
    >
      <Form.Description text="Tanooki Auth is now showing a 6-digit code. Type it here and press Enter." />
      <Form.TextField
        id="code"
        title="Code"
        placeholder="000 000"
        error={codeError}
        onChange={() => setCodeError(undefined)}
      />
    </Form>
  );
}
