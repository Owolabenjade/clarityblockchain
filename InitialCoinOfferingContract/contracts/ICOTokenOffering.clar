;; Define constants
(define-constant TOKEN_COST u100) ;; Price per token in STX
(define-constant SALE_DURATION u604800) ;; Duration of ICO in seconds (1 week)
(define-constant COIN_SYMBOL "ICO-TOKEN") ;; The symbol of the token

;; Define data variables
(define-data-var total-tokens uint u0) ;; Total supply of ICO tokens
(define-data-var user-balances (map principal uint) (map)) ;; Correctly initialize the map
(define-data-var contract-owner principal tx-sender) ;; Owner of the ICO contract
(define-data-var sale-end-time uint (+ block-height SALE_DURATION)) ;; End time of the ICO

;; Define a public function to buy tokens
(define-public (purchase-ttokens (token-amount uint))
  (let ((total-cost (* token-amount TOKEN_COST)))
    (if (<= block-height (var-get sale-end-time))
        (if (is-ok (stx-transfer? total-cost tx-sender (var-get contract-owner)))
            (begin
              (map-set user-balances tx-sender (+ (default-to u0 (map-get? user-balances tx-sender)) token-amount))
              (var-set total-tokens (+ (var-get total-tokens) token-amount))
              (ok (unwrap-panic (map-get? user-balances tx-sender)))
            )
            (err u1) ;; Error in STX transfer
        )
        (err u2) ;; ICO has ended
    )
  )
)

;; Define a public function to finalize the ICO
(define-public (end-sale)
  (if (is-eq tx-sender (var-get contract-owner))
      (if (> block-height (var-get sale-end-time))
          (ok (stx-transfer? (var-get total-tokens) tx-sender (var-get contract-owner)))
          (err u3) ;; ICO not yet ended
      )
      (err u4) ;; Only owner can finalize
  )
)

;; Define a read-only function to check the balance of an address
(define-read-only (check-balance (user-address principal))
  (default-to u0 (map-get? user-balances user-address))
)

;; Define a read-only function to check the remaining time of the ICO
(define-read-only (time-left)
  (ok (- (var-get sale-end-time) block-height))
)
