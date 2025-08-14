
(cl:in-package :asdf)

(defsystem "spar_msgs-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :actionlib_msgs-msg
               :geometry_msgs-msg
               :std_msgs-msg
)
  :components ((:file "_package")
    (:file "FlightMotionAction" :depends-on ("_package_FlightMotionAction"))
    (:file "_package_FlightMotionAction" :depends-on ("_package"))
    (:file "FlightMotionActionFeedback" :depends-on ("_package_FlightMotionActionFeedback"))
    (:file "_package_FlightMotionActionFeedback" :depends-on ("_package"))
    (:file "FlightMotionActionGoal" :depends-on ("_package_FlightMotionActionGoal"))
    (:file "_package_FlightMotionActionGoal" :depends-on ("_package"))
    (:file "FlightMotionActionResult" :depends-on ("_package_FlightMotionActionResult"))
    (:file "_package_FlightMotionActionResult" :depends-on ("_package"))
    (:file "FlightMotionFeedback" :depends-on ("_package_FlightMotionFeedback"))
    (:file "_package_FlightMotionFeedback" :depends-on ("_package"))
    (:file "FlightMotionGoal" :depends-on ("_package_FlightMotionGoal"))
    (:file "_package_FlightMotionGoal" :depends-on ("_package"))
    (:file "FlightMotionResult" :depends-on ("_package_FlightMotionResult"))
    (:file "_package_FlightMotionResult" :depends-on ("_package"))
  ))