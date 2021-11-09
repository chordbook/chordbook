// https://github.com/buzcarter/UkeGeeks
/* global ace */

import snippetText from './chordpro.snippets'

ace.define('ace/snippets/chordpro', ['require', 'exports', 'module'], function (require, exports, module) {
  exports.snippetText = snippetText
  exports.scope = 'chordpro'
})
