// https://github.com/buzcarter/UkeGeeks

/* global ace */

const { define } = ace

define('ace/mode/chordpro', ['require', 'exports', 'module', 'ace/lib/oop', 'ace/mode/text', 'ace/mode/chordpro_highlight_rules'], function (require, exports, module) {
  const oop = require('../lib/oop')
  const TextMode = require('./text').Mode
  const ChordproHighlightRules = require('./chordpro_highlight_rules').ChordproHighlightRules

  const Mode = function () {
    this.HighlightRules = ChordproHighlightRules
  }

  oop.inherits(Mode, TextMode);

  (function () {
    this.createWorker = function (session) {
      return null
    }

    this.$id = 'ace/mode/chordpro'
    this.snippetFileId = 'ace/snippets/chordpro'
  }).call(Mode.prototype)

  exports.Mode = Mode
})

define('ace/mode/chordpro_highlight_rules', ['require', 'exports', 'module', 'ace/lib/oop', 'ace/mode/text_highlight_rules'], function (require, exports, module) {
  const oop = require('../lib/oop')

  const TextHighlightRules = require('./text_highlight_rules').TextHighlightRules

  const ChordproHighlightRules = function () {
    // capture groups
    const reOpenBrace = '(^\\s*{)' // no spaces allowed between "{" and the command, removed \\s*
    const reCloseBrace = '(\\s*}\\s*$)'
    const reColon = '(\\s*:)'
    // stand alone
    const reNumber = '\\b[0-9]+\\b'

    // token (CSS classes names)
    const tkBrace = 'meta.tag'
    const tkCommand = 'meta'
    const tkSingleTag = 'entity.name'

    this.$rules = {
      start: [{
        token: 'comment',
        regex: '^#.*$' // debated this, for now MUST be first character (otherwise allow \\s*)
      }, {
        token: [tkBrace, tkSingleTag, tkBrace],
        regex: reOpenBrace + '(column_break|new_page|np|colb|start_of_verse|sov|end_of_verse|eov|start_of_chorus|soc|end_of_chorus|eoc)' + reCloseBrace,
        caseInsensitive: true
      }, {
        token: [tkBrace, tkSingleTag, tkBrace],
        regex: reOpenBrace + '(start_of_tab|sot)' + reCloseBrace,
        caseInsensitive: true,
        next: 'tabBlockTag'
      }, {
        token: [tkBrace, tkCommand, tkBrace],
        regex: reOpenBrace + '(define)' + reColon,
        caseInsensitive: true,
        next: 'defineTag'
      }, {
        // tkCommand?
        token: [tkBrace, 'meta', tkBrace, 'text', tkBrace],
        regex: reOpenBrace + '(c|comment)' + reColon + '(.*)' + reCloseBrace,
        caseInsensitive: true
      }, {
        token: [tkBrace, tkCommand, tkBrace, 'string', tkBrace],
        regex: reOpenBrace + '(title|t|subtitle|st|artist|album|instrument|tuning|key|k|capo)' + reColon + '(.*)' + reCloseBrace,
        caseInsensitive: true
      }, {
        token: [tkBrace, 'invalid', tkBrace, 'string', tkBrace],
        regex: reOpenBrace + '([-\\S]+)' + reColon + '(.*)' + reCloseBrace,
        caseInsensitive: true
      }, {
        token: [tkBrace, 'invalid', tkBrace],
        regex: reOpenBrace + '(.+)' + reCloseBrace,
        caseInsensitive: true
      }, {
        token: 'constant.numeric',
        regex: reNumber
      }, {
        token: ['constant.character.escape', 'keyword', 'constant.character.escape'],
        regex: '(\\[)(.*?)(\\])'
      }, {
        token: 'text',
        regex: '\\s+'
      }],

      defineTag: [{
        token: tkBrace,
        regex: reCloseBrace,
        next: 'start'
      }, {
        token: 'constant.mumeric',
        regex: reNumber
      }, {
        token: 'keyword.control',
        regex: '\\b(fingers|frets|finger|fret|string)\\b',
        caseInsensitive: true
      }, {
        token: [tkCommand, tkBrace],
        regex: '\\b(add)' + reColon,
        caseInsensitive: true
      }, {
        defaultToken: 'string'
      }],

      tabBlockTag: [{
        token: [tkBrace, tkSingleTag, tkBrace],
        regex: reOpenBrace + '(end_of_tab|eot)' + reCloseBrace,
        caseInsensitive: true,
        next: 'start'
      }, {
        token: 'comment.line',
        regex: '-+'
      }, {
        token: 'constant.character',
        regex: '\\|+'
      }, {
        token: 'string',
        regex: '[a-gA-G][b#]?'
      }, {
        token: 'constant.mumeric',
        regex: reNumber
      }, {
        defaultToken: 'comment'
      }]
    }
  }

  oop.inherits(ChordproHighlightRules, TextHighlightRules)

  exports.ChordproHighlightRules = ChordproHighlightRules
})
