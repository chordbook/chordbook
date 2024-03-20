import { defineComponent, shallowRef, onMounted, onBeforeUnmount, h, watch } from 'vue'
import { onIonViewDidEnter } from '@ionic/vue'
import { extensions } from '@chordbook/editor'
import { EditorState } from '@codemirror/state'
import { EditorView } from '@codemirror/view'
import debounce from 'lodash.debounce'

export default defineComponent({
  name: 'Editor',

  props: {
    modelValue: {
      type: String,
      default: ''
    }
  },

  emits: ['update:modelValue', 'ready', 'focus', 'blur', 'paste'],

  setup (props, context) {
    const container = shallowRef()
    const state = shallowRef()
    const view = shallowRef()

    onMounted(() => {
      state.value = EditorState.create({
        doc: props.modelValue,
        extensions: [
          ...extensions,
          // https://discuss.codemirror.net/t/codemirror-6-proper-way-to-listen-for-changes/2395/11
          EditorView.updateListener.of(debounce((v) => {
            if (v.docChanged) context.emit('update:modelValue', v.state.doc.toString(), v)
            if (v.focusChanged) context.emit(v.view.hasFocus ? 'focus' : 'blur', v)
          }, 300)),
          EditorView.domEventHandlers({
            paste (event, view) {
              context.emit('paste', event, view)
            }
          })
        ]
      })

      view.value = new EditorView({
        state: state.value,
        parent: container.value,
        root: document
      })

      window.editor = view.value

      watch(
        () => props.modelValue,
        (value) => {
          if (value !== view.value.state.doc.toString()) {
            view.value.dispatch({ changes: { from: 0, to: view.value.state.doc.length, insert: value } })
            view.value.focus()
          }
        }
      )

      context.emit('ready', { state: state.value, view: view.value, container: container.value })

      setTimeout(() => view.value.focus(), 100)
    })

    onIonViewDidEnter(() => view.value.focus())
    onBeforeUnmount(() => view.value.destroy())

    return () => {
      return h('div', { class: 'h-full', ref: container })
    }
  }
})
