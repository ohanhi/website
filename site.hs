--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}

import Control.Applicative (Alternative (..))
import Control.Monad as Monad
import Data.Maybe (fromMaybe)
import Data.Monoid (mappend)
import Hakyll
import Network.HTTP.Base (urlEncode)
import System.FilePath (splitExtension)

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
  match "img/**" $ do
    route idRoute
    compile copyFileCompiler

  match "css/*" $ do
    route idRoute
    compile compressCssCompiler

  match "js/*" $ do
    route idRoute
    compile copyFileCompiler

  match "posts/*" $ do
    route $ customRoute $ pathToPostName . toFilePath
    compile postCompiler

  match "drafts/*" $ do
    route $ setExtension "html"
    compile postCompiler

  match "index.html" $ do
    route idRoute
    compile $ do
      posts <- loadAll "posts/*" >>= recentFirst
      let indexCtx =
            listField "posts" postCtx (return posts)
              `mappend` defaultContext

      getResourceBody
        >>= applyAsTemplate indexCtx
        >>= loadAndApplyTemplate "templates/default.html" indexCtx
        >>= relativizeUrls

  match "CNAME" $ do
    route idRoute
    compile copyFileCompiler

  match "robots.txt" $ do
    route idRoute
    compile copyFileCompiler

  match "keybase.txt" $ do
    route idRoute
    compile copyFileCompiler

  match "templates/*" $ compile templateBodyCompiler

  create ["atom.xml"] $ do
    route idRoute
    compile $ do
      let feedCtx = postCtx `mappend` bodyField "description"
      posts <-
        fmap (take 15) . recentFirst
          =<< loadAllSnapshots "posts/*" "content"
      renderAtom feedConfig feedCtx posts

postCompiler :: Compiler (Item String)
postCompiler =
  pandocCompiler
    >>= loadAndApplyTemplate "templates/post-content.html" postCtx
    >>= saveSnapshot "content"
    >>= loadAndApplyTemplate "templates/post.html" postCtx
    >>= relativizeUrls

pathToPostName :: String -> String
pathToPostName path =
  path
    |> splitAll "/"
    |> (\(p : name : _) -> splitExtension name)
    |> (\(n, e) -> n ++ ".html")

(|>) = flip ($)

--------------------------------------------------------------------------------

feedConfig :: FeedConfiguration
feedConfig =
  FeedConfiguration
    { feedTitle = "ohanhi.dev",
      feedDescription = "Posts from my personal website.",
      feedAuthorName = "Ossi Hanhinen",
      feedAuthorEmail = "ossi.hanhinen@gmail.com",
      feedRoot = "https://ohanhi.dev"
    }

postCtx :: Context String
postCtx =
  dateField "date" "%B %-d, %Y"
    `mappend` constField "base_url" "https://ohanhi.dev"
    `mappend` fullTitleField "full_title" False
    `mappend` fullTitleField "twitter_text" True
    `mappend` twitterUrlField "https://ohanhi.dev"
    `mappend` listContextWith "i_expect_you_to_know"
    `mappend` listContextWith "read_this_to"
    `mappend` defaultContext

twitterUrlField :: String -> Context a
twitterUrlField baseUrl =
  field "twitter_url" $
    fmap (maybe empty (\a -> urlEncode $ baseUrl ++ toUrl a)) . getRoute . itemIdentifier

fullTitleField :: String -> Bool -> Context a
fullTitleField fieldName urlEncoded = field fieldName $ \item -> do
  metadata <- getMetadata (itemIdentifier item)
  let find s = lookupString s metadata
  (find "series", find "title", find "subtitle")
    |> ( \(series, title, subtitle) ->
           fromMaybe "" (fmap (\s -> s ++ ": ") series)
             ++ fromMaybe "No title" title
             ++ fromMaybe "" (fmap ((++) " - ") subtitle)
       )
    |> (if urlEncoded then urlEncode else \a -> a)
    |> return

listContextWith :: String -> Context a
listContextWith s =
  getList s
    |> listField s defaultContext

getList :: String -> Compiler [Item String]
getList s = do
  identifier <- getUnderlying
  metadata <- getMetadata identifier
  metadata
    |> lookupStringList s
    |> fromMaybe []
    |> map toItem
    |> return

toItem x =
  Item (fromFilePath x) x
