# ICO Smart Contract in Clarity

## Overview

This repository contains a smart contract written in Clarity for conducting an Initial Coin Offering (ICO) on the Stacks blockchain. The contract allows users to purchase tokens during a specified period (the ICO duration) and provides the contract owner with the ability to finalize the ICO once it ends. The contract ensures security and transparency by utilizing the Clarity programming language, known for its decidability and prevention of reentrancy attacks.

## Features

- **Token Purchase**: Users can purchase tokens by sending STX (Stacks tokens) to the contract during the ICO period.
- **Ownership Control**: Only the contract owner can finalize the ICO and withdraw the raised funds.
- **Balance Check**: Users can check their token balance at any time.
- **ICO Duration**: The ICO has a predefined duration after which token sales are automatically halted.

## Contract Details

### Constants

- `TOKEN_COST`: The price of one token in STX.
- `SALE_DURATION`: The duration of the ICO in seconds (e.g., 604800 seconds for one week).
- `COIN_SYMBOL`: The symbol of the token being sold in the ICO.

### Data Variables

- `total-tokens`: Tracks the total number of tokens sold during the ICO.
- `user-balances`: A mapping of user addresses to their respective token balances.
- `contract-owner`: The address of the ICO contract owner who has the authority to finalize the ICO.
- `sale-end-time`: The block height at which the ICO ends.

### Functions

#### Public Functions

1. **`purchase-tokens (token-amount uint)`**
   - Allows users to purchase a specified number of tokens by transferring STX to the contract.
   - Validates that the ICO is still active and the STX transfer is successful before updating the user's balance and total tokens sold.

2. **`end-sale`**
   - Allows the contract owner to finalize the ICO and transfer the raised STX funds to the owner's address.
   - Can only be called by the contract owner after the ICO has ended.

#### Read-Only Functions

1. **`check-balance (user-address principal)`**
   - Returns the token balance of the specified user address.

2. **`time-left`**
   - Returns the remaining time (in block height) for the ICO to be active.

## Usage Instructions

### Prerequisites

- You need a Stacks-compatible wallet to interact with the contract.
- STX tokens are required to purchase the ICO tokens.

### Deploying the Contract

1. **Clone the Repository:**
   ```
   git clone <repository-url>
   cd <repository-folder>
   ```

2. **Compile the Contract:**
   Use the Stacks CLI or a compatible IDE to compile the contract.

3. **Deploy the Contract:**
   Deploy the contract to the Stacks testnet or mainnet using your preferred method.

### Interacting with the Contract

1. **Buying Tokens:**
   - Call the `purchase-tokens` function, specifying the number of tokens you wish to buy.
   - Ensure you have sufficient STX in your wallet to cover the purchase.

2. **Finalizing the ICO:**
   - The contract owner can call the `end-sale` function to finalize the ICO and withdraw the raised funds after the ICO period ends.

3. **Checking Token Balance:**
   - Use the `check-balance` function to check how many tokens you own.

4. **Checking Remaining ICO Time:**
   - Use the `time-left` function to see how much time remains before the ICO ends.

### Example Commands

- **Purchase Tokens:**
  ```clarity
  (purchase-tokens u100)
  ```
  This command purchases 100 tokens at the specified TOKEN_COST.

- **Finalize ICO:**
  ```clarity
  (end-sale)
  ```
  This command finalizes the ICO and transfers the raised STX to the contract owner.

- **Check Balance:**
  ```clarity
  (check-balance 'SP2H6Y75QW5HQ4A1W5T7NQPA9Q8FZKPTWJH6RZGBR)
  ```
  This command checks the token balance of the specified address.

- **Check Remaining Time:**
  ```clarity
  (time-left)
  ```
  This command returns the remaining ICO time in block height.

## Security Considerations

- **Ownership**: Only the contract owner can finalize the ICO, ensuring control over the funds.
- **No Reentrancy**: Clarity's design prevents reentrancy attacks, enhancing the contract's security.
- **Error Handling**: The contract includes error handling to ensure smooth operation and proper feedback to users.

## Contributing

If you find any issues or have suggestions for improvements, feel free to open an issue or submit a pull request. Contributions are always welcome!

## Disclaimer

This contract is provided as-is and is intended for educational purposes. Use it at your own risk. The authors are not responsible for any losses incurred through the use of this smart contract.

## Author

Benjamin Owolabi