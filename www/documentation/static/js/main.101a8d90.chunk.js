(this["webpackJsonpreact-markdown-documentation"]=this["webpackJsonpreact-markdown-documentation"]||[]).push([[0],{172:function(e,t,r){},173:function(e,t,r){},549:function(e,t,r){"use strict";r.r(t);var n=r(19),a=r(0),c=r.n(a),o=r(18),l=r.n(o),i=(r(172),r(164)),s=(r(173),r(583)),d=r(1),u=r(162),h=r.n(u),b=r(572),p=r(574),j=r(585),m=r(575),g=r(576),f=r(577),x=r(578),O=r(579),y=r(580),v=r(581),k=r(147),w=r.n(k),C=r(584),N=r(571),S=r(5);function T(e){var t=/language-(\w+)/.exec(e.className||"");if(e.inline)return Object(S.jsx)("code",Object(n.a)({style:{background:"".concat(d.a.blue.lightest)}},e));var r=t?t[1]:"text";return Object(S.jsx)(C.a,Object(n.a)({style:N.a,language:r,PreTag:"pre",children:String(e.children).replace(/\n$/,"")},e))}function q(){return"_self"in c.a.createElement("div")}var z=r(152),B=r.n(z),I=r(153),D=r.n(I);function E(e){return e["data-sourcepos"]?{"data-sourcepos":e["data-sourcepos"]}:{}}function L(e){function t(e){var t=c.a.Children.toArray(e.children).reduce((function e(t,r){return"string"===typeof r?t+r:c.a.Children.toArray(r.props.children).reduce(e,t)}),""),r=t.replace(/\s+/g,"-").replace(/\./g,"-").replace(/-+/g,"-").replace(/-$/g,"").replace(/(?<=\d)-(\d)/g,"$1").replace(/[^a-zA-Z0-9-]/g,"").toLowerCase(),n=e.level>1?{marginTop:"5px",marginBottom:"5px"}:{marginBottom:"5px"};return Object(S.jsx)(b.a,{id:"head-"+r,variant:"h".concat(e.level+1),color:"primary",style:n,children:e.children})}function r(e){var t=E(e);return null!==e.start&&1!==e.start&&void 0!==e.start&&(t.start=e.start.toString()),c.a.createElement(e.ordered?"ol":"ul",t,e.children)}function a(e){return Object(S.jsx)("li",{children:Object(S.jsx)(b.a,Object(n.a)(Object(n.a)({component:"span"},E(e)),{},{variant:"body2",children:e.children}))})}var o=function(e){var t=Object(p.a)({disableHysteresis:!0,threshold:100});return Object(S.jsx)(j.a,{in:t,children:Object(S.jsx)("div",{onClick:function(e){var t=(e.target.ownerDocument||document).querySelector("#back-to-top-anchor");t&&t.scrollIntoView({behavior:"smooth",block:"center"})},role:"presentation",style:{position:"fixed",bottom:"20px",right:"20px",zIndex:9e3},children:e.children})})};return Object(S.jsxs)("div",{style:{padding:"10px",paddingLeft:"20px"},children:[Object(S.jsx)("div",{id:"back-to-top-anchor"}),Object(S.jsx)(w.a,{plugins:[B.a,D.a],className:"result",components:{a:function(e){var t="footnote-backref"===e.className?e.href.substring(1,3)+e.href.substring(6):null;return Object(S.jsx)("span",{id:t,onClick:function(t){var r=null;e.href.startsWith("http")||e.href.startsWith("www")?window.open(e.href,"_blank"):(r="footnote-backref"===e.className||"footnote-ref"===e.className?(t.target.ownerDocument||document).querySelector(e.href):(t.target.ownerDocument||document).querySelector("#head-"+e.href.substring(1)))&&r.scrollIntoView({behavior:"smooth",block:"start"})},style:{cursor:"pointer",color:"blue",textDecoration:"underline"},children:e.children})},blockquote:function(e){return Object(S.jsx)("blockquote",{style:{margin:0,paddingLeft:"1em",borderLeft:"0.5em ".concat(d.a.blue.lightest," solid")},children:e.children})},code:T,em:"em",h1:t,h2:t,h3:t,h4:t,h5:t,h6:t,br:"br",hr:"hr",img:function(e){var t="..".concat(e.src.substring(1)),r="..".concat(e.alt.substring(1));return q()&&(t=e.src,r=e.alt),Object(S.jsx)("img",{style:{maxWidth:"calc(100vw - 40px)"},alt:r,src:t})},ul:r,ol:r,li:a,input:function(e){return Object(S.jsx)(s.a,{checked:e.checked,disabled:!0,size:"small",style:{padding:"3px"}})},p:function(e){return Object(S.jsx)(b.a,{style:{marginBottom:"8pt",marginTop:"8pt"},variant:"body1",children:e.children})},pre:"div",strong:"strong",thematicBreak:"hr",del:"del",heading:t,list:r,listItem:a,table:function(e){return Object(S.jsx)(m.a,{children:Object(S.jsx)(g.a,{children:e.children})})},thead:f.a,tbody:x.a,tr:O.a,td:y.a,th:y.a,dl:"dl",dt:"dt",dd:"dd"},children:e.source}),Object(S.jsx)(o,{children:Object(S.jsx)(v.a,{color:"primary",size:"small","aria-label":"scroll back to top",children:Object(S.jsx)(h.a,{style:{color:"white"}})})})]})}var A=function(){var e=c.a.useState(""),t=Object(i.a)(e,2),r=t[0],n=t[1],o=q()?"./documentation.md":"../documentation.md";return Object(a.useEffect)((function(){fetch(o).then((function(e){return e.text()})).then((function(e){n(e)}))}),[o]),Object(S.jsx)("div",{className:"result-pane",children:Object(S.jsx)(L,{className:"result",source:r})})},M=r(582),W=r(163),$=r(65),G={props:{MuiTableCell:{align:"left"}},overrides:{MuiTableCell:{head:Object(n.a)({backgroundColor:d.a.blueGray.lighter,textTransform:"uppercase"},$.a.typography.caption),body:Object(n.a)(Object(n.a)({padding:d.b.normal},$.a.typography.body1),{},{color:d.a.blueGray.dark,fontSize:"1rem"})},MuiTableRow:{root:{"&:nth-of-type(even)":{backgroundColor:"rgba(0, 0, 0, 0.02)"},"&:hover":{backgroundColor:"rgba(3, 169, 244, 0.1)"}}}}},J=Object(W.a)($.a,G);l.a.render(Object(S.jsx)(M.a,{theme:J,children:Object(S.jsx)(A,{})}),document.getElementById("root"))}},[[549,1,2]]]);