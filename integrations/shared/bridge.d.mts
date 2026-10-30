export class BridgeError extends Error {
  code: string;
  constructor(code: string, message: string);
}

export interface AccountWithCode {
  id: string;
  type: "totp" | "hotp";
  issuer: string;
  label: string;
  domains: string[];
  /** null for HOTP accounts: ask with code(). */
  code: string | null;
  /** Epoch ms when the code expires; null for HOTP. */
  expiresAt: number | null;
}

export interface BridgeClient {
  origin: string;
  keychain: { get(): Promise<string | null>; set(token: string): Promise<void>; clear(): Promise<void> };
  listCodes(): Promise<AccountWithCode[]>;
  code(accountId: string): Promise<{ code: string; secondsLeft: number | null }>;
  pairStart(): Promise<{ pending: true }>;
  pairFinish(code: string): Promise<{ ok: true }>;
}

export function createClient(name: string, displayName?: string): BridgeClient;
export function groupCode(code: string): string;
