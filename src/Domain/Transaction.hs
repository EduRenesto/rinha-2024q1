{-# LANGUAGE ExistentialQuantification #-}

module Domain.Transaction where
import Control.Monad.IO.Class

data Transaction
  = Transaction
  { amount :: Int
  , description :: String
  , date :: String
  }

-- TODO(edu): como separar isso em enums
-- diferentes de maneira esperta?
data TransactionError
  = UserNotFound
  | NotEnoughLimit
  | Unknown String

class HasTransaction a where
  insertTransaction
    :: MonadIO m
    => a      -- | Environment
    -> Int    -- | UserID
    -> Int    -- | Amount
    -> String -- | Description
    -> m (Either () TransactionError)

  getTransactions
    :: MonadIO m
    => a
    -> Int
    -> m (Either [Transaction] TransactionError)
