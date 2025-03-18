import SwiftUI

struct ExerciseDetailView: View {
    // Subscribes to an external class (like a ViewModel) that conforms to ObservableObject.
    // Updates the view when the observed object changes.
    @ObservedObject var viewModel: ExerciseViewModel
    // When the value changes, SwiftUI automatically re-renders the view.
    @State var exercise: Exercise
    
    // Accesses environment values provided by the system or parent views (e.g., device orientation, dark mode, or presentation mode).
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Exercise Name").font(.headline)) {
                    TextField("...", text: $exercise.name)
                }
                
                Section(header: Text("Exercise Type").font(.headline)) {
                    TextField("...", text: $exercise.type)
                }
                
                Section(header: Text("Target Muscle").font(.headline)) {
                    TextField("...", text: $exercise.muscle)
                }
                
                Section(header: Text("Difficulty Level").font(.headline)) {
                    TextField("...", text: $exercise.difficulty)
                }
            }
            
            Spacer()
            
            HStack(spacing: 10) {
                Button(action: {
                    viewModel.updateExercise(exercise: exercise)
                    // Screen disappears after updating exercise
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "square.and.pencil")
                        Text("Save changes")
                    }
                    .foregroundColor(.white)
                    .frame(width: 170, height: 50)
                    .background(Color.blue)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                
                Button(action: {
                    viewModel.deleteExercise(id: exercise.id)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete exercise")
                    }
                    .foregroundColor(.white)
                    .frame(width: 170, height: 50)
                    .background(Color.red)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("Exercise details")
    }
}
