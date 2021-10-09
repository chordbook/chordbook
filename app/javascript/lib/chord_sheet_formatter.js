import Handlebars from "handlebars"
import "chordsheetjs/lib/handlebars_helpers";

const template = Handlebars.compile(`
{{~#with song~}}
  {{~#if title~}}
    <h1>{{~title~}}</h1>
  {{~/if~}}

  {{~#if subtitle~}}
    <h2>{{~subtitle~}}</h2>
  {{~/if~}}
  {{~#if artist~}}
    <h2>by {{artist}}</h2>
  {{~/if~}}

  <div class="chord-sheet">
    {{~#each paragraphs as |paragraph|~}}
      <div class="{{paragraphClasses paragraph}}">
        {{~#each lines as |line|~}}
          {{~#if (shouldRenderLine line)~}}
            <div class="{{lineClasses line}}">
              {{~#each items as |item|~}}
                {{~#if (isChordLyricsPair item)~}}
                  <div class="column"><div data-name="{{chords}}" class="chord">{{chords}}</div>
                    {{~#if (hasTextContents line)~}}
                      <div class="lyrics">{{lyrics}}</div>
                    {{~/if~}}
                  </div>
                {{~/if~}}

                {{~#if (isTag item)~}}
                  {{~#if (isComment item)~}}
                    <div class="comment">{{value}}</div>
                  {{~/if~}}
                {{~/if~}}
              {{~/each~}}
            </div>
          {{~/if~}}
        {{~/each~}}
      </div>
    {{~/each~}}
  </div>
{{~/with~}}`)

// Custom HTML formatter for chordsheets
export default class ChordSheetFormatter {
  format(song) {
    return template({ song }, { allowProtoPropertiesByDefault: true });
  }
}
