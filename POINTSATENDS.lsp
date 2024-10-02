(princ (strcat "
					Author - Robert Stokłosa
					Available commands:
					PointsAtEnds - inserts points at the ends of selected lines and polylines.
                    Orange points are located on a new layer named Points at Ends.
") )

(vl-load-com)

(defun createLayer ()
    (if (not (tblsearch "layer" "Points at Ends"))
        (entmake (list  (cons 0 "LAYER")
                        (cons 100 "AcDbSymbolTableRecord")
                        (cons 100 "AcDbLayerTableRecord")
                        '(2 . "Points at Ends")
                        '(70 . 0)
                        '(62 . 30)
                        '(6 . "Continuous")
                )
        )
    )
) ;The function checks the layer ‘Points at Ends’. If the layer is not in the drawing, it is created.

(defun drawPoint (pt)
    (entmakex   (list   (cons 0 "POINT")
                        (cons 10 pt)
                        (cons 8 "Points at Ends")
                )
    )
) ;The function inserts points at the coordinates ‘pt’ on the ‘Points at Ends’ layer.
                 
(defun C:PointsAtEnds ( / ss i pt ent)
    (createLayer)
    (setq ss (ssget (list (cons 0 "LINE,POLYLINE,LWPOLYLINE")))) ;Selection of lines and polylines.
    (setq i 0)
    (repeat (sslength ss)
        (setq ent (ssname ss i))
        (setq pt (vlax-curve-getStartPoint (vlax-ename->vla-object ent)))
        (drawPoint pt) ;Start point
        (setq pt (vlax-curve-getEndPoint (vlax-ename->vla-object ent)))
        (drawPoint pt) ;End point
        (setq i (+ i 1))
    )
)