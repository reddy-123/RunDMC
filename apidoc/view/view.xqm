xquery version "1.0-ml";
(: Library of apidoc view functions. :)

module namespace v="http://marklogic.com/rundmc/api/view" ;

declare default function namespace "http://www.w3.org/2005/xpath-functions";

import module namespace api="http://marklogic.com/rundmc/api"
  at "/apidoc/model/data-access.xqy" ;

(: This is an html view library so it is tempting to declare
 : xhtml as the default element namespace.
 : But some of the content has elements in the empty namespace,
 : which would cause problems.
 :)
declare namespace xhtml="http://www.w3.org/1999/xhtml" ;

declare function v:site-title($version as xs:string)
as xs:string
{
  switch($version)
  case '5.0' return 'MarkLogic 5 Product Documentation'
  case '6.0' return 'MarkLogic 6 Product Documentation'
  case '7.0' return 'MarkLogic 7 Product Documentation'
  case '8.0' return 'MarkLogic 8 Early Access Product Documentation'
  default return concat(
    'MarkLogic Server ', $version, ' Product Documentation')
};

declare function v:external-guide-uri(
  $version-prefix as xs:string,
  $guide-doc as document-node())
as xs:string
{
  api:external-uri-with-prefix(
    $version-prefix, $guide-doc/*/@guide-uri)
};

declare function v:string-normalize($str as xs:string)
as xs:string
{
  normalize-space(
    lower-case(
      translate($str, '&#160;', ' ')))
};

declare function v:config-for-title(
  $link as xs:string,
  $auto-links as element()*,
  $other-guide-listings as element()*)
as element()?
{
  (: TODO This looks pretty inefficient.
   : Maybe compare using a collation that ignores case and all whitespace?
   :)
  let $title := v:string-normalize($link)
  return $other-guide-listings[
    (@display|alias)/v:string-normalize(.) = $title]
  |$auto-links[
    alias/v:string-normalize(.) = $title]
};

declare function v:guide-image-attribute($a as attribute())
as attribute()
{
  typeswitch($a)
  case attribute(src) return attribute src {
    (: Resolve the relative image URI according to the current guide :)
    concat(api:guide-image-dir(base-uri($a)), $a) }
  default return $a
};

declare function v:guide-attributes($e as element())
as attribute()*
{
  typeswitch($e)
  case element(xhtml:img) return v:guide-image-attribute($e/@*)
  default return $e/@*
};

declare function v:apidoc-copyright()
as element()
{
  (: Use absolute links so they work uniformly on standalone docs app. :)
  <div xmlns="http://www.w3.org/1999/xhtml"
  id="copyright">Copyright &#169; 2014 MarkLogic Corporation. All rights reserved.
  | Powered by
  <a href="http://developer.marklogic.com/products">
  MarkLogic Server
  <span class="server-version">{ xdmp:version() }</span>
  </a>
  and <a href="http://developer.marklogic.com/code/rundmc">rundmc</a>.
  </div>
};

(: apidoc/view/view.xqm :)