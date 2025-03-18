import SwiftUI

struct AddExerciseView: View {
    var exerciseViewModel: ExerciseViewModel
    // When the value changes, SwiftUI automatically re-renders the view.
    @State private var name = ""
    @State private var type = ""
    @State private var muscle = ""
    @State private var difficulty = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Exercise Name").font(.headline)) {
                    TextField("...", text: $name)
                }
                
                Section(header: Text("Exercise Type").font(.headline)) {
                    TextField("...", text: $type)
                }
                
                Section(header: Text("Target Muscle").font(.headline)) {
                    TextField("...", text: $muscle)
                }
                
                Section(header: Text("Difficulty Level").font(.headline)) {
                    TextField("...", text: $difficulty)
                }
            }
            
            Spacer()
            
            Button(action: {
                if !name.isEmpty {
                    exerciseViewModel.addExercise(name: name, type: type, muscle: muscle, difficulty: difficulty)
                    // Screen disappears after adding exercise
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add exercise")
                }
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(name.isEmpty ? Color.gray : Color.blue)
                .cornerRadius(15)
                .shadow(radius: 5)
            }
            .disabled(name.isEmpty)
            .padding(.bottom, 20)
        }
        .navigationTitle("Add exercise")
    }
}
