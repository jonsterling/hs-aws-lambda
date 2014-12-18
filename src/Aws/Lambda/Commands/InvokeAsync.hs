-- Copyright (c) 2013-2014 PivotCloud, Inc.
--
-- Aws.Lambda.Commands.InvokeAsync
--
-- Please feel free to contact us at licensing@pivotmail.com with any
-- contributions, additions, or other feedback; we would love to hear from
-- you.
--
-- Licensed under the Apache License, Version 2.0 (the "License"); you may
-- not use this file except in compliance with the License. You may obtain a
-- copy of the License at http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
-- WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
-- License for the specific language governing permissions and limitations
-- under the License.

{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE UnicodeSyntax #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Aws.Lambda.Commands.InvokeAsync
( -- * Request
  InvokeAsync(..)
, invokeAsync
  -- ** Lenses
, iaFunctionName

  -- * Response
, InvokeAsyncResponse(..)
, iarStatus
) where

import Aws.Lambda.Core

import Control.Applicative
import Control.Applicative.Unicode
import Control.Lens
import Data.Aeson
import qualified Data.Text as T
import Network.HTTP.Types

data InvokeAsync
  = InvokeAsync
  { _iaFunctionName ∷ !T.Text
  } deriving (Eq, Show)

makeLenses ''InvokeAsync

-- | A minimal 'InvokeAsync' request.
--
invokeAsync
  ∷ T.Text -- ^ '_iaFunctionName'
  → InvokeAsync
invokeAsync = InvokeAsync

data InvokeAsyncResponse
  = InvokeAsyncResponse
  { _iarStatus ∷ !Int
  } deriving (Eq, Show)

makeLenses ''InvokeAsyncResponse

instance FromJSON InvokeAsyncResponse where
  parseJSON =
    withObject "InvokeAsyncResponse" $ \o →
      pure InvokeAsyncResponse
        ⊛ o .: "Status"

instance LambdaTransaction InvokeAsync InvokeAsyncResponse where
  buildQuery ia =
    lambdaQuery POST ["functions", ia ^. iaFunctionName, "invoke-async"]