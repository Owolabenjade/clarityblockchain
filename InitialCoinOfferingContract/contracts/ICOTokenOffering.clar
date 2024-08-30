;; Define constants
(define-constant TOKEN_COST u100) ;; Price per token in STX
(define-constant SALE_DURATION u604800) ;; Duration of ICO in seconds (1 week)
(define-constant COIN_SYMBOL "ICO-TOKEN") ;; The symbol of the token
(define-constant MAX_TOKENS u10000) ;; Maximum number of tokens available for sale

;; Define data variables
(define-data-var total-tokens uint u0) ;; Total supply of ICO tokens
(define-data-var user-balances (map principal uint) (into-map-value (list 1) (list u0))) ;; User balances initialized with an empty map
(define-data-var contract-owner principal tx-sender) ;; Owner of the ICO contract
(define-data-var sale-end-time uint (+ block-height SALE_DURATION)) ;; End time of the ICO

;; Define a public function to buy tokens
(define-public (purchase-tokens (token-amount uint))
  (let ((total-cost (* token-amount TOKEN_COST))
        (current-balance (default-to u0 (map-get? user-balances tx-sender))))
    (if (<= block-height (var-get sale-end-time))
        (if (<= (+ (var-get total-tokens) token-amount) MAX_TOKENS)
            (if (is-ok (stx-transfer? total-cost tx-sender (var-get contract-owner)))
                (begin
                  (map-set user-balances tx-sender (+ current-balance token-amount))
                  (var-set total-tokens (+ (var-get total-tokens) token-amount))
                  (ok (unwrap-panic (map-get? user-balances tx-sender)))
                )
                (err u1) ;; Error in STX transfer
            )
            (err u5) ;; Exceeds maximum token supply
        )
        (err u2) ;; ICO has ended
    )
  )
)

;; Define a public function to finalize the ICO
(define-public (end-sale)
  (if (is-eq tx-sender (var-get contract-owner))
      (if (> block-height (var-get sale-end-time))
          (begin
            (let ((remaining-tokens (- MAX_TOKENS (var-get total-tokens))))
              (if (> remaining-tokens 0)
                  (stx-transfer? remaining-tokens (var-get contract-owner) tx-sender) ;; Transfer remaining tokens to owner
                  (ok u0) ;; No remaining tokens to transfer
              )
            )
          )
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