## 2025-05-18 - Defer CSV Column Parsing
**Learning:** In Swift CSV parsing routines, generating column-oriented mappings eagerly in `init` performs O(N * H) dictionary lookups and array allocations during initial app launch, even if `columns` is never read by any view controller.
**Action:** Always make secondary CSV representations (like column dictionaries) `lazy` properties so computation occurs only if and when accessed.
