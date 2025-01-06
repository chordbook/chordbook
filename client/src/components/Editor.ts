import { detectFormat } from "@/composables";
import { createEditor } from "@chordbook/editor";
import { linter } from "@codemirror/lint";
import { EditorState } from "@codemirror/state";
import { EditorView } from "@codemirror/view";
import { ChordProFormatter, ChordProParser } from "chordsheetjs";
import { computed, defineComponent, h, onBeforeUnmount, onMounted, shallowRef, watch } from "vue";

import type { TransactionSpec } from "@codemirror/state";
import type { parser } from "peggy";

// Transaction Filter to convert pasted text to ChordPro format
const convertOnPaste = EditorState.transactionFilter.of((tr) => {
  // Don't do anything if the change is not a paste event
  if (!tr.isUserEvent("input.paste")) return tr;

  const newTr: TransactionSpec[] = [];

  tr.changes.iterChanges((fromA, toA, _fromB, _toB, inserted) => {
    let text = inserted.toString();
    // Detect the format of the pasted text
    const format = detectFormat(text);

    // If it's not ChordPro, convert it
    if (format && !(format instanceof ChordProParser)) {
      text = new ChordProFormatter().format(format.parse(text));
    }

    // Create a new transaction with the formatted text
    newTr.push({
      changes: { from: fromA, to: toA, insert: text },
      selection: { anchor: fromA + text.length },
    });
  });

  return newTr;
});

export default defineComponent({
  name: "Editor",

  props: {
    modelValue: {
      type: String,
      default: "",
    },
    error: {
      type: Error,
      default: null,
    },
  },

  emits: ["update:modelValue", "ready"],

  setup(props, context) {
    const container = shallowRef();
    const view = shallowRef();

    const onChange = ({ detail }: { detail: { doc: string } }) => {
      context.emit("update:modelValue", detail.doc);
    };

    onMounted(() => {
      view.value = createEditor({
        parent: container.value,
        root: document,
        doc: props.modelValue,
        extensions: [
          EditorView.theme({
            "&": {
              height: "100%",
              overflow: "hidden",
            },
            ".cm-scroller": {
              flex: "1",
              overflow: "auto",
            },
          }),
          convertOnPaste,
          linter(() => {
            if (!props.error) return [];

            console.log(props.error);

            const { message, location } = props.error as parser.SyntaxError;
            return [
              {
                from: location.start.offset,
                to: location.end.offset,
                severity: "error",
                message,
              },
            ];
          }),
        ],
      });

      // Expose editor to tests
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      (<any>window).editor = view.value;

      watch(
        () => props.modelValue,
        (value) => {
          if (value !== view.value.state.doc.toString()) {
            view.value.dispatch({
              changes: {
                from: 0,
                to: view.value.state.doc.length,
                insert: value,
              },
            });
            view.value.focus();
          }
        },
      );
      context.emit("ready", { view: view.value, container: container.value });

      setTimeout(() => view.value.focus(), 100);
    });

    onBeforeUnmount(() => view.value.destroy());

    context.expose({ scroller: computed(() => view.value?.scrollDOM) });

    return () => {
      return h("div", { class: "contents", ref: container, onChange });
    };
  },
});
