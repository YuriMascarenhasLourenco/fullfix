import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 10 },
    { duration: '1m', target: 50 },
    { duration: '1m', target: 100 },
    { duration: '30s', target: 0 },
  ],

  thresholds: {
    http_req_duration: ['p(95)<500'],
    http_req_failed: ['rate<0.01'],
  },
};

const BASE_URL = 'http://localhost:3000';

export default function () {
  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };
  const payload = JSON.stringify({
    customerId: 1,
    item: [
      { id: 1, name: 'Sample Product', quantity: 1, price: 100 },
      { id: 2, name: 'Another Product', quantity: 2, price: 200 },
      { id: 3, name: 'Third Product', quantity: 3, price: 300 },
      { id: 4, name: 'Fourth Product', quantity: 4, price: 400 },
      { id: 5, name: 'Fifth Product', quantity: 5, price: 500 },
    ],
    quantity: 1,
    price: 100,
  });
  const response = http.post(`${BASE_URL}/orders`, payload, params);

  check(response, {
    'status is 200': (r) => r.status === 200,
    'response below 500ms': (r) => r.timings.duration < 500,
  });

  sleep(1);
}
