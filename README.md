# PostgREST in Elm

This package creates a pleasant experience for interacting with PostgREST in Elm.

## Design Goals

The design of the package is based on 2 central ideas:

1.  **The PostgREST specification is not important to application authors.** More generally, the Transfer Protocol (HTTP) and the Interchange Format (JSON) are often inessential details of the data request layer of your application. Therefore, where applicable, requests are thought of at the level of "REST requests built from a schema" rather than "HTTP requests transfering JSON data".

2.  **Invalid PostgREST requests are equivalent to runtime errors.** And, because this is Elm, you should not be able to generate runtime errors! Therefore, where feasible, invalid requests generate compiler errors rather than HTTP errors.


## Example

Let's take a look at an example. Say you have a PostgREST data server filled with [NCES school data](https://nces.ed.gov/). You wish to fetch all of the schools' id and name fields where the school is in the state of California and then order them alphabetically. Let's take a look at how you'd build the request without this package:

```elm
import Http
import Json.Decode as Json

type alias School =
    { id : Int
    , name : String
    }

request : Http.Request (List School)
request =
    Http.get "https://api.com/schools?select=id,name&state=eq.CA&order=asc.name" (Decode.list decoder)

decoder : Json.Decoder School
decoder =
    map2
        (Json.field "id")
        (Json.field "name")
```

As demonstrated above, in the standard approach, you must build an HTTP GET request to the url `https://api.com/schools?select=id,name&state=eq.CA&order=asc.name` (Transfer Protocol) and decode the JSON response to your desired data structure (Interchange Format). The request code 1.) contains inessential details of the PostgREST specification (ie. HTTP and JSON) and 2.) is prone to invalid construction (because of heavy string usage).

Now, let's take a look at how you'd build the request with this package:

```elm
import PostgRest as Rest
import Schema

type alias School =
    { id : Int
    , name : String
    }

request : Rest.Request (List School)
request =
    Rest.readMany Schema.school
        { select = selection
        , where_ = Rest.eq "CA" .state
        , order = [ Rest.asc .name ]
        , limit = Nothing
        , offset = Nothing
        }

selection : Rest.Selection { a | id : Attribute Int, name : Attribute String } School
selection =
    Rest.map2
        (Rest.field .id)
        (Rest.field .name)
```

As demonstrated above, this package leads to a more pleasant experience for interacting with PostgREST in Elm. The request code 1.) contains only the essential details of the data request and 2.) is no longer prone to invalid construction (because the strings are gone). Pretty cool.

> You may have noticed that the above example does not provide a definition for `Schema.school`. Dig into the [docs](http://package.elm-lang.org/packages/john-kelly/elm-postgrest/latest/PostgRest) to learn more!

## Additional Resources
- [Official Documentation](http://package.elm-lang.org/packages/john-kelly/elm-postgrest/latest)
- [Simple Examples: elm-postgrest/examples](https://github.com/john-kelly/elm-postgrest/tree/master/examples)
- [Complex Example: elm-postgrest-spa-example](https://github.com/john-kelly/elm-postgrest-spa-example)
- [Blog Posts](https://foldp.com)
