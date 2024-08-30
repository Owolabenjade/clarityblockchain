(define-data-var recipient principal none)
(define-data-var total-vested uint u0)
(define-data-var start-block uint u0)
(define-data-var duration uint u0)
(define-data-var total-claimed uint u0)

(define-public (initialize (recipient principal) (total-vested uint) (duration uint))
  (begin
    ;; Ensure that the contract is initialized only once
    (asserts! (is-none (var-get recipient)) (err u100))
    ;; Set the recipient, total vested amount, and duration
    (var-set recipient (some recipient))
    (var-set total-vested total-vested)
    (var-set duration duration)
    (var-set start-block (block-height))
    (ok u0)
  )
)

(define-read-only (calculate-vested)
  (let
    (
      (initial-block (var-get start-block))
      (vesting-period (var-get duration))
      (amount-vested (var-get total-vested))
      (elapsed-time (- (block-height) initial-block))
    )
    ;; Calculate the vested amount based on time passed
    (if (< elapsed-time vesting-period)
        (* amount-vested (/ elapsed-time vesting-period))
        amount-vested
    )
  )
)

(define-read-only (calculate-claimable)
  (let
    (
      (vested (unwrap-panic (calculate-vested)))
      (already-claimed (var-get total-claimed))
    )
    ;; Calculate the claimable amount by subtracting already claimed tokens
    (- vested already-claimed)
  )
)

(define-public (claim-vested)
  (let
    (
      (current-recipient (unwrap! (var-get recipient) (err u101)))
      (claimable-amount (unwrap-panic (calculate-claimable)))
    )
    ;; Ensure the caller is the recipient
    (asserts! (is-eq tx-sender current-recipient) (err u102))
    ;; Ensure there is something to claim
    (asserts! (> claimable-amount u0) (err u103))
    ;; Transfer the claimable amount to the recipient
    (begin
      (stx-transfer? claimable-amount tx-sender)
      (var-set total-claimed (+ (var-get total-claimed) claimable-amount))
      (ok claimable-amount)
    )
  )
)
