import { defineComponent, shallowRef, onMounted, onBeforeUnmount, h, watch } from 'vue'
import { onIonViewDidEnter } from '@ionic/vue'
import { createEditor } from '@chordbook/editor'

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
    const view = shallowRef()

    const events = {
      onChange (doc) { context.emit('update:modelValue', doc) },
      onFocus (v) { context.emit('focus', v) },
      onBlur (v) { context.emit('blur', v) },
      onPaste (event, v) { context.emit('paste', event, v) }
    }

    onMounted(() => {
      view.value = createEditor({
        parent: container.value,
        root: document,
        state: {
          doc: props.modelValue,
          events
        }
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

    onIonViewDidEnter(() => view.value.focus())
    onBeforeUnmount(() => view.value.destroy())

    return () => {
      return h('div', { class: 'h-full', ref: container })
    }
  }
})
