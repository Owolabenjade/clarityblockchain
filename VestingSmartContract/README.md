# Vesting Smart Contract - Clarity

## Overview

This Clarity smart contract is designed to manage token vesting on the Stacks blockchain. The contract allows a specified recipient to claim vested tokens over time according to a predefined vesting schedule. The vesting process ensures that tokens are gradually made available to the recipient, preventing them from claiming the entire amount upfront.

## Features

- **Initialization**: The contract can be initialized once with a recipient, a total vested amount, and a vesting duration.
- **Vesting Calculation**: The contract calculates the vested amount based on the time elapsed since the vesting start.
- **Claiming Tokens**: The recipient can claim the vested tokens incrementally as they become available according to the vesting schedule.

## Contract Structure

### Variables

- **`recipient`**: The principal (address) of the recipient who will receive the vested tokens.
- **`total-vested`**: The total amount of tokens to be vested over the duration.
- **`start-block`**: The block height at which the vesting starts.
- **`duration`**: The duration over which the tokens will be vested, measured in blocks.
- **`total-claimed`**: The total amount of tokens that have already been claimed by the recipient.

### Functions

#### 1. `initialize`

```clarity
(define-public (initialize (recipient principal) (total-vested uint) (duration uint)) ...)
```

- **Description**: Initializes the contract by setting the recipient, total vested amount, and vesting duration. This function can only be called once.
- **Parameters**:
  - `recipient`: The principal (address) of the recipient.
  - `total-vested`: The total amount of tokens to be vested.
  - `duration`: The duration over which the tokens will vest, measured in blocks.
- **Returns**: A confirmation (`u0`) if successful, or an error if the contract has already been initialized.

#### 2. `calculate-vested`

```clarity
(define-read-only (calculate-vested) ...)
```

- **Description**: Calculates the amount of tokens that have vested based on the time elapsed since the vesting start.
- **Returns**: The amount of tokens that have vested.

#### 3. `calculate-claimable`

```clarity
(define-read-only (calculate-claimable) ...)
```

- **Description**: Calculates the amount of vested tokens that the recipient can currently claim, accounting for any tokens that have already been claimed.
- **Returns**: The amount of tokens that are currently claimable.

#### 4. `claim-vested`

```clarity
(define-public (claim-vested) ...)
```

- **Description**: Allows the recipient to claim the vested tokens. This function ensures that only the claimable amount is transferred to the recipient.
- **Returns**: The amount of tokens successfully claimed, or an error if the operation fails.

## Usage

### Deployment

1. **Deploy the Contract**: Deploy the contract to the Stacks blockchain.
2. **Initialize the Contract**: Call the `initialize` function with the appropriate parameters to set the recipient, total vested amount, and vesting duration.

### Interacting with the Contract

- **Check Vested Amount**: Use the `calculate-vested` function to see how many tokens have vested at any point in time.
- **Check Claimable Amount**: Use the `calculate-claimable` function to determine how many tokens are available for claiming.
- **Claim Tokens**: The recipient can call the `claim-vested` function to claim the available vested tokens.

## Error Codes

- **`u100`**: The contract has already been initialized. Initialization can only happen once.
- **`u101`**: The recipient address has not been set, or the recipient is not valid.
- **`u102`**: The function caller is not the recipient.
- **`u103`**: There are no tokens available to claim at the moment.

## Considerations

- **Vesting Period**: The vesting schedule is linear and tied to the block height. The recipient can only claim tokens as they vest over time.
- **One-time Initialization**: The contract can only be initialized once to ensure the integrity of the vesting process.
- **Recipient Responsibility**: It is the recipient's responsibility to claim the tokens as they vest. Unclaimed tokens remain in the contract until they are claimed.

## Future Enhancements

- **Custom Vesting Schedules**: Support for more complex vesting schedules, such as cliff periods or graded vesting.
- **Multi-recipient Support**: Allow multiple recipients with individual vesting schedules.
- **Early Withdrawal Penalties**: Implement penalties for early withdrawals or restrictions on claiming before a certain period.

## License

This smart contract is open-source and available under the MIT License.