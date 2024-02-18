{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty

import Domain.Context
import Domain.Transaction

import Controllers.InsertTransaction

data RinhaEnv
  = RinhaEnv
  {}

instance HasTransaction RinhaEnv where
  insertTransaction _ userId amt desc = do
    return $ Left ()

  getTransactions _ userId = do
    return $ Right UserNotFound

mkEnv :: IO RinhaEnv
mkEnv = do
  return env
  where
    env = RinhaEnv {}

main :: IO ()
main = do
  env <- mkEnv

  scotty 9999 $ do
    post "/clientes/:userId/transacoes" $ handleInsertTransaction env
