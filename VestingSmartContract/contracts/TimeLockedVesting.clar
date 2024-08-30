(define-data-var recipient (optional principal) none)
(define-data-var total-vested uint u0)
(define-data-var start-block uint u0)
(define-data-var duration uint u0)
(define-data-var total-claimed uint u0)

;; Custom max function
(define-read-only (max (a uint) (b uint))
  (if (> a b) a b)
)

(define-public (initialize (beneficiary principal) (vesting-amount uint) (vesting-duration uint))
  (begin
    ;; Ensure the contract is not initialized twice
    (asserts! (is-none (var-get recipient)) (err u100))
    ;; Ensure valid input parameters
    (asserts! (> vesting-amount u0) (err u104))
    (asserts! (> vesting-duration u0) (err u105))
    ;; Set the recipient, total vested amount, and duration
    (var-set recipient (some beneficiary))
    (var-set total-vested vesting-amount)
    (var-set duration vesting-duration)
    (var-set start-block block-height)
    (ok (tuple (recipient beneficiary) (total-vested vesting-amount) (duration vesting-duration)))
  )
)

(define-read-only (calculate-vested)
  (let
    (
      (initial-block (var-get start-block))
      (vesting-period (var-get duration))
      (amount-vested (var-get total-vested))
      (elapsed-time (max u0 (- block-height initial-block)))
    )
    ;; Calculate the vested amount based on time passed
    (if (< elapsed-time vesting-period)
        (/ (* amount-vested elapsed-time) vesting-period)
        amount-vested
    )
  )
)

(define-read-only (calculate-claimable)
  (let
    (
      (vested (calculate-vested))
      (already-claimed (var-get total-claimed))
    )
    ;; Calculate the claimable amount by subtracting already claimed tokens
    (ok (- vested already-claimed))
  )
)

(define-public (claim-vested)
  (let
    (
      (current-recipient (unwrap! (var-get recipient) (err u101)))
      (claimable (unwrap-panic (calculate-claimable)))
    )
    ;; Ensure the caller is the recipient
    (asserts! (is-eq tx-sender current-recipient) (err u102))
    ;; Ensure there is something to claim
    (asserts! (> claimable u0) (err u103))
    ;; Transfer the claimable amount to the recipient
    (try! (stx-transfer? claimable tx-sender current-recipient))
    ;; Update the claimed amount if the transfer was successful
    (var-set total-claimed (+ (var-get total-claimed) claimable))
    (print (tuple (event "claimed") (amount claimable)))
    (ok claimable)
  )
)
