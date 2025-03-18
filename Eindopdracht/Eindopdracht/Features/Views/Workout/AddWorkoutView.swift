import SwiftUI

struct AddWorkoutView: View {
    // When the value changes, SwiftUI automatically re-renders the view.
    @State private var workoutName: String = ""
    // Accesses environment values provided by the system or parent views (e.g., device orientation, dark mode, or presentation mode).
    @Environment(\.presentationMode) var presentationMode
    var viewModel: WorkoutViewModel
    
    var body: some View {
        VStack {
            Text("Workout name")
                .font(.headline)
            
            TextField("...", text: $workoutName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                if !workoutName.isEmpty {
                    viewModel.addWorkout(name: workoutName)
                    presentationMode.wrappedValue.dismiss() // Dismisses the current view.
                }
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add workout")
                }
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(workoutName.isEmpty ? Color.gray : Color.blue)
                .cornerRadius(15)
                .shadow(radius: 5)
            }
            .disabled(workoutName.isEmpty)
            .padding(.bottom, 20)
        }
        .padding()
    }
}
