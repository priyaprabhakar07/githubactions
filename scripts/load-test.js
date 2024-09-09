import http from 'k6/http';
import { check, sleep } from 'k6';

// Store the server list in a global variable
const servers = [
  'http://bar.localhost:8081',
  'http://foo.localhost:8080',
];

let currentServerIndex = 0;

export default function () {
  // Cycle through the servers
  const url = servers[currentServerIndex];
  currentServerIndex = (currentServerIndex + 1) % servers.length;

  const res = http.get(url);
  check(res, { 'is status 200': (r) => r.status === 200 });
  
  sleep(1); // Adjust the sleep time as needed
}
