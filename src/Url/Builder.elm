module Url.Builder
    exposing
        ( QueryParameter
        , crossOrigin
        , string
        , toQuery
        )

{- Adjusted from https://github.com/elm/url/blob/rc1-1.0.0/src/Url/Builder.elm -}

import Http


crossOrigin : String -> List String -> List QueryParameter -> String
crossOrigin prePath pathSegments parameters =
    prePath ++ "/" ++ String.join "/" pathSegments ++ toQuery parameters


type QueryParameter
    = QueryParameter String String


string : String -> String -> QueryParameter
string key value =
    QueryParameter (Http.encodeUri key) (Http.encodeUri value)


toQuery : List QueryParameter -> String
toQuery parameters =
    case parameters of
        [] ->
            ""

        _ ->
            "?" ++ String.join "&" (List.map toQueryPair parameters)


toQueryPair : QueryParameter -> String
toQueryPair (QueryParameter key value) =
    key ++ "=" ++ value
