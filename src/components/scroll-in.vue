<template>
  <div ref="scrollInInstance">
    <slot />
  </div>
</template>

<script>
import { defineComponent, onMounted, reactive, ref, unref } from '@vue/composition-api'
import throttle from '../utils/throttle'
import '../assets/css/scroll-in.css'

export default defineComponent({
  props: {
    animation: {
      type: String,
      default: 'fade'
    },
    top: {
      type: Boolean,
      default: false
    },
    bottom: {
      type: Boolean,
      default: false
    },
    duration: {
      type: [String, Number],
      default: '0.3'
    },
    delay: {
      type: [String, Number],
      default: '0'
    }
  },
  setup (props) {
    const scrollInInstance = ref(null)
    const elBounding = reactive({
      top: 0,
      height: 0
    })

    const initScrollElement = () => {
      const pageSrcollTop = document.documentElement.scrollTop
      const bounding = unref(scrollInInstance).getBoundingClientRect()
      elBounding.top = bounding.top + pageSrcollTop
      elBounding.height = bounding.height

      const { isInTheView } = getElementPosition()

      unref(scrollInInstance).style.setProperty('--scroll-in-duration', `${String(props.duration)}s`)
      unref(scrollInInstance).style.setProperty('--scroll-in-delay', `${String(props.delay)}s`)
      unref(scrollInInstance).classList.add(`scroll-in-${props.animation}`, `scroll-in-${props.animation}__hide`)

      if (isInTheView) {
        window.onload = () => {
          setTimeout(() => {
            unref(scrollInInstance).classList.add(`scroll-in-${props.animation}__show`)
          }, 30)
        }
        if (document.readyState === 'complete') {
          setTimeout(() => {
            unref(scrollInInstance).classList.add(`scroll-in-${props.animation}__show`)
          }, 30)
        }
      }
      window.addEventListener('scroll', throttle(scrollHandler, 100))
    }

    const getElementPosition = () => {
      const pageSrcollTop = document.documentElement.scrollTop
      const elOffsetTop = elBounding.top
      const elHeight = elBounding.height

      const viewHeight = document.documentElement.clientHeight
      const viewTopBoundary = pageSrcollTop
      const viewBottomBoundary = pageSrcollTop + viewHeight - elHeight

      const isOnTheView = (elOffsetTop + elHeight) < viewTopBoundary
      const isInTheView = (elOffsetTop + elHeight) > viewTopBoundary && elOffsetTop < viewBottomBoundary
      const isUnderView = elOffsetTop > viewBottomBoundary

      return {
        isOnTheView,
        isInTheView,
        isUnderView
      }
    }

    const scrollHandler = () => {
      const { isOnTheView, isInTheView, isUnderView } = getElementPosition()

      if (
        (isOnTheView && props.top) ||
        (isUnderView && props.bottom)
      ) {
        unref(scrollInInstance).classList.remove(`scroll-in-${props.animation}__show`)
      }

      if (isInTheView) {
        unref(scrollInInstance).classList.add(`scroll-in-${props.animation}__show`)
      }
    }

    onMounted(() => {
      initScrollElement()
    })

    return {
      scrollInInstance,
      elBounding
    }
  }
})
</script>
