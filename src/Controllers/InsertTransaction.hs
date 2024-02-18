{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Controllers.InsertTransaction where

import Control.Monad.IO.Class

import Domain.Transaction
import Web.Scotty.Trans
import Network.HTTP.Types.Status

import GHC.Generics

import Data.Aeson (FromJSON, ToJSON)

data HandleTransactionReq
  = HandleTransactionReq
  { valor :: Float
  , tipo :: String
  , descricao :: String
  } deriving (Generic)

instance FromJSON HandleTransactionReq where
  -- empty

getNormalizedAmount :: HandleTransactionReq -> Int
getNormalizedAmount req
  | tipo req == "c" = toFixed val
  | otherwise       = toFixed $ negate val
  where
    toFixed = truncate . (* 10)
    val = valor req

data HandleTransactionRes
  = HandleTransactionRes
  { limite :: Float
  , saldo :: Float
  } deriving (Generic)

instance ToJSON HandleTransactionRes where
  -- empty

handleInsertTransaction
  :: (HasTransaction a, MonadIO m)
  => a
  -> ActionT m ()
handleInsertTransaction env = do
  userId :: Int <- pathParam "userId"
  req :: HandleTransactionReq <- jsonData
  result <- insertTransaction env userId (getNormalizedAmount req) (descricao req)
  case result of
    Left _             -> json $ HandleTransactionRes { limite = 100.0
                                                      , saldo = 100.0 }
    Right UserNotFound -> do
      status status404
      text "User not found"
    Right _            -> do
      status status422
      text "Not enough limit"
