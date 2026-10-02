import http from 'k6/http';
import { check } from 'k6';

export const options = {
  scenarios: {
    concurrent_users: {
      executor: 'constant-vus',
      vus: 10,
      iterations: 100,
      maxDuration: '30s',
    },
  },
};

export default function () {
  const response = http.post(
    'http://localhost:3000/purchase',
    JSON.stringify({
      productId: 1,
      quantity: 1,
    }),
    {
      headers: {
        'Content-Type': 'application/json',
      },
    },
  );

  check(response, {
    'request completed': (r) => r.status === 200 || r.status === 400,
  });
}
