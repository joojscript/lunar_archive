export type ScanResult = {
  host: string;
  port: number | string;
  status: 'OPEN' | 'CLOSED';
};
