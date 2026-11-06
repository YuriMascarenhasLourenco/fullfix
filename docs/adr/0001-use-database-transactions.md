# ADR 0001: Preventing Inventory Overselling

**Status:** Accepted

**Date:** 2026-11-06

## Context

The inventory purchasing process currently uses a read-modify-write operation.

When multiple users attempt to purchase the same product simultaneously, concurrent requests may read the same inventory quantity and both successfully deduct stock.

This can result in negative inventory and overselling.

We need a concurrency control mechanism that guarantees inventory consistency.

## Decision

We decided to use atomic conditional updates inside a database transaction.

The inventory deduction will only succeed when the available quantity is greater than or equal to the requested quantity.

We will use SQL batch to update quantities of all items in one query

Retries for failed transactions are also in the scope for temporary failures, allowing a new attempt without the user's try to make the operation again manually

## Alternatives Considered

1. **Application-level validation:** Rejected because checking inventory before updating does not prevent concurrent modifications.
2. **Pessimistic locking:** Not selected as the initial approach because conditional atomic updates provide a simpler solution for this use case.
3. **Optimistic locking:** Not selected initially because it introduces version management 

## Consequences

### Positive

- Prevents overselling through atomic conditional updates.
- Reduces the race condition window.
- Keeps the concurrency guarantee at the database level.

### Negative

- Requires handling failed conditional updates.
- Transaction management is necessary when multiple inventory records must be updated together.
- Concurrent requests may contend for the same database rows.

### Future Considerations

Evaluate optimistic and pessimistic locking under higher contention and compare their performance through load testing.