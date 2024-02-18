module Domain.Context where

import Domain.Transaction
import Control.Monad.Reader

newtype UserID = UserID String

-- data RinhaContext
--   = RinhaContext
--   { mkInsertTransaction :: HasInsertTransaction
--   , mkGetTransactions :: HasGetTransactions
--   }

-- newtype RinhaM a
--   = RinhaM
--   { runRinhaM :: ReaderT RinhaContext IO a
--   } deriving (Functor, Applicative, Monad, MonadIO, MonadReader RinhaContext)
