import Toybox.Activity;

module Shared_IQ_3_2_0 {
    
    (:Workout)
    module Workout {

        // Represents a type that can provide the current workout step.
        typedef CurrentWorkoutStepProvider as interface {

            // Returns the current workout step or null if there's no active workout.
            function getCurrentWorkoutStep() as WorkoutStep?;
        };

        // A class that provides the current workout step as provided by 'Activity'.
        //
        // This class checks whether the current workout step is a WorkoutIntervalStep or not and gets
        // the actual current workout step accordingly.
        class ActivityCurrentWorkoutStepProvider {
            // TODO: Do we need to pass activity here? Can't be just directly use it?
            function initialize(activity as Activity) {
                mActivity = activity;
            }

            // Returns the current workout step or null if there's no active workout.
            function getCurrentWorkoutStep() as WorkoutStep? {
                if (!(mActivity has :getCurrentWorkoutStep)) {
                    return null;
                }
                var stepInfo = mActivity.getCurrentWorkoutStep();
                if (stepInfo == null) {
                    return null;
                }
                var stepOrInterval = stepInfo.step;
                if (stepOrInterval instanceof Activity.WorkoutIntervalStep) {
                    return stepOrInterval.activeStep;
                }
                return stepOrInterval;
            }

            private var mActivity as Activity;
        }

        (:debug)
        module UnitTests {

            // A class to mock the current workout step.
            class MockCurrentWorkoutStepProvider {
                function getCurrentWorkoutStep() as WorkoutStep? {
                    return mWorkoutStep;
                }

                var mWorkoutStep as WorkoutStep? = new Activity.WorkoutStep();
            }
        }
    }
}