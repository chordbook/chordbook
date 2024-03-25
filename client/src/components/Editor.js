import { defineComponent, shallowRef, onMounted, onBeforeUnmount, h, watch } from 'vue'
import { createEditor } from '@chordbook/editor'
import { linter } from '@codemirror/lint'

export default defineComponent({
  name: 'Editor',

  props: {
    modelValue: {
      type: String,
      default: ''
    },
    error: {
      type: Error,
      default: null
    }
  },

  emits: ['update:modelValue', 'ready'],

  setup (props, context) {
    const container = shallowRef()
    const view = shallowRef()

    const onChange = (e) => { context.emit('update:modelValue', e.detail.doc) }

    onMounted(() => {
      view.value = createEditor({
        parent: container.value,
        root: document,
        doc: props.modelValue,
        extensions: [
          linter(view => {
            if (!props.error) return []

            const { message, location } = props.error
            return [{
              from: location.start.offset,
              to: location.end.offset,
              severity: 'error',
              message
            }]
          })
        ]
      })

      // Expose editor to tests
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

      context.emit('ready', { view: view.value, container: container.value })

      setTimeout(() => view.value.focus(), 100)
    })

    onBeforeUnmount(() => view.value.destroy())

    return () => {
      return h('div', { class: 'h-full', ref: container, onChange })
    }
  }
})