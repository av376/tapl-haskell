module Language.Arith.Parser
  (
   parseString
  ) where

import Language.Arith.Syntax
import Language.Arith.Lexer
import Text.ParserCombinators.Parsec

parseString :: String -> Either ParseError Term
parseString = parse parseExpr ""

parseExpr :: Parser Term
parseExpr = parens parseExpr
         <|> parseIf
         <|> (reserved "true" >> return TmTrue)
         <|> (reserved "false" >> return TmFalse)
         <|> parseNum

parseNum :: Parser Term
parseNum = (reserved "0" >> return TmZero)
        <|> parsePred
        <|> parseSucc
        <|> parseIsZero

parsePred :: Parser Term
parsePred = do reserved "pred"
               t <- parseExpr
               return (TmPred t)

parseSucc :: Parser Term
parseSucc = do reserved "succ"
               t <- parseExpr
               return (TmSucc t)

parseIsZero :: Parser Term
parseIsZero = do reserved "iszero"
                 t <- parseExpr
                 return (TmIsZero t)

parseIf :: Parser Term
parseIf = do reserved "if"
             t1 <- parseExpr
             reserved "then"
             t2 <- parseExpr
             reserved "else"
             t3 <- parseExpr
             return $ TmIf t1 t2 t3
