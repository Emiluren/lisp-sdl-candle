(require :sdl2)

(defun test-render-clear (renderer)
  (sdl2:set-render-draw-color renderer 0 0 0 255)
  (sdl2:render-clear renderer))

(defparameter *time* 0)

(defun test-render-candle (renderer x h)
  (sdl2:set-render-draw-color renderer 255 255 255 255)
  (sdl2:render-fill-rect renderer (sdl2:make-rect (- x 20) (- 600 h) 40 h))
  (sdl2:set-render-draw-color renderer
                              255
                              (+ 230 (floor (* (sin (* 0.23 *time*)) 20)))
                              0
                              255)
  (let ((flame-height (+ 50 (floor (* 10 (sin (* 0.05 *time*))))))
        (flame-width (+ 10 (floor (* 5 (sin (* 0.05 *time*)))))))
    (sdl2:render-fill-rect renderer (sdl2:make-rect (- x (floor flame-width 2))
                                                    (- 600 h flame-height)
                                                    flame-width
                                                    flame-height)))
  )

(defun renderer-test ()
  "Test the SDL_render.h API"
  (sdl2:with-init (:everything)
    (sdl2:with-window (win :title "SDL2 Renderer API Demo" :flags '(:shown))
      (sdl2:with-renderer (renderer win :flags '(:accelerated))
        (sdl2:with-event-loop (:method :poll)
          (:keyup
           (:keysym keysym)
           (when (sdl2:scancode= (sdl2:scancode-value keysym) :scancode-escape)
             (sdl2:push-event :quit)))
          (:idle
           ()
           (test-render-clear renderer)
           (loop for (x . h) in '((200 . 200)
                                  (300 . 300)
                                  (400 . 400)
                                  (500 . 300)
                                  (600 . 200))
              do (test-render-candle renderer x h))
           (sdl2:render-present renderer)
	   (sdl2:delay 33)
           (incf *time* 1))
          (:quit () t))))))
