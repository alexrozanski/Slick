//
//  EdgeCoordinates.swift
//  Aurora
//
//  Created by Alex Rozanski on 03/01/2023.
//

import Foundation

/*
    Calculate the coordinates for a point on the edge of a rectangle given an angle.

    The vector maths is based on this answer: https://math.stackexchange.com/a/1760644, where we
    center the rectangle at the origin:

                        θ' = 90deg
                             ↑
                             |   |v|
                 ↑ +---------|---/-----+
                 | |     +---|--/      |
            h/2  | |    / θ' | /       |
                 ↓ |   /     |/        |
    θ' = 0deg --------+------+---------------> θ' = 180deg
                 ↑ |         |         |
            h/2  | |         |         |
                 | |         |         |
                 ↓ +---------|---------+

                       θ' = 270deg

                   <--------> <-------->
                      w/2         w/2

     - Our input `angle`, θ is defined where 0deg is the top left corner of the rectangle and sweeps
       clockwise round the rectangle, but we define our θ' where 0deg is the direction of the unit
       vector { -1, 0 }.
     - Therefore θ' = θ + 45deg.
     - For some unit vector |u| = {cos(θ'), sin(θ')}, we want to find a vector |v| (as per the
       Stack Exchange answer) where |v| = λ|u| and solve for some value of λ.

    We define |v| as (multiplying |u| by λ):

          ⌈    ⌈ h.cos(θ')     w.cos(θ')  ⌉ ⌉
          | min|----------    ----------- | |
     →    |    ⌊ 2|cos(θ')| ,  2|sin(θ')| ⌋ |
     v  = |                                 |
          |    ⌈ h.sin(θ')     w.sin(θ')  ⌉ |
          | min|----------    ----------- | |
          ⌊    ⌊ 2|cos(θ')| ,  2|sin(θ')| ⌋ ⌋

    And label the first and second terms to min() for the x value of |v| as `t1` and `t2`, and
    the first and second terms to min() for the y value of |v| as `t3` and `t4`.

    In `t1`, cos(θ') on the top and bottom cancel out, and in `t4` the sin(θ') on the top and
    bottom cancel out, so we simplify `t1` and `t4` to (h/2) and (w/2) respectively. This also
    simplifies our calculations because we don't have to account for division by zero.

    However we still need to account for the case where cos(θ') or sin(θ') is negative, as this
    will change the sign of our `t1` and `t4` values (because we divide cos(θ') by |cos(θ')| and
    sin(θ') by |cos(θ')| respectively). We use `t1Sign` and `t4Sign` for this.

    The min()s in the original equation are to ignore division by zero values (in these cases we
    set `t2` and `t4` to infinity) but these crucially should only be applied to the magnitude of
    (t1, t2) and (t3, t4) to ignore the infinity values. If we applied them to the signed values
    of t1 and t4 some of the results are incorrect. Instead of calculating min()s we do a
    simple < comparison with the abs() values of (t1, t2) and (t3, t4).

    Since the vector maths gives us points on a rectangle centered on a Cartesian grid at (0, 0)
    we need to transform |v| to be in the coordinate space of the image. We do this by
    translating |v| by (w/2, -h/2) and then flipping the y coordinates by multiplying by -1.

    Finally we clamp the values of x and y to 0 <= x <= width and 0 <= y <= height.

    NOTE: these coordinates are not completely right - some are off by a pixel or 2 because of
    rounding/precision errors. But these are good enough for what we need so this isn't a huge
    deal.
 */
func edgeCoordinates(for angle: Double, inRectWithSize rectSize: CGSize) -> CGPoint {
  let width = rectSize.width
  let height = rectSize.height

  // Calculate θ'
  let normalizedAngle = ((angle + 45) * .pi) / 180

  // Determine the signs for t1 and t4
  let t1Sign = cos(normalizedAngle) < 0 ? -1.0 : 1.0
  let t4Sign = sin(normalizedAngle) < 0 ? -1.0 : 1.0

  let t1 = t1Sign * (height / 2.0)
  let t2 = abs(sin(normalizedAngle)) < Double.ulpOfOne ? Double.infinity : (width * cos(normalizedAngle)) / (2 * abs(sin(normalizedAngle)))
  let t3 = abs(cos(normalizedAngle)) < Double.ulpOfOne ? Double.infinity : (height * sin(normalizedAngle)) / (2 * abs(cos(normalizedAngle)))
  let t4 = t4Sign * (width / 2.0)

  // Because of how the signs of cos() and sin() work out, we need to multiply the x value by -1 and leave y as-is. There's probably
  // some maths-y way to fix this but I'll leave this for now.
  let (xMultiplier, yMultiplier) = (x: -1.0, y: 1.0)

  // Translate the image centered at (0, 0) to the top-left being at (0, 0)
  let (xTranslation, yTranslation) = (width / 2.0, (-1 * height) / 2)

  let xTerm = abs(t1) < abs(t2) ? t1 : t2
  let yTerm = abs(t3) < abs(t4) ? t3 : t4

  let x = round(xMultiplier * xTerm + xTranslation)

  // Since the top left of the image is now at (0, 0), flip the y coordinates so that the bottom right of the image is at (width, height) on the grid.
  let y = -1 * (yMultiplier * yTerm + yTranslation)

  // Clamp x and y such that 0 <= x <= width and 0 <= y <= height and they are integral values.
  return CGPoint(
    x: round(min(max(x, 0.0), width)),
    y: round(min(max(y, 0.0), height))
  )
}
