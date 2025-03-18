import SwiftUI

struct ExerciseListView: View {
    // Subscribes to an external class (like a ViewModel) that conforms to ObservableObject.
    // Updates the view when the observed object changes.
    @ObservedObject var viewModel: ExerciseViewModel
    // When the value changes, SwiftUI automatically re-renders the view.
    @State private var showAddExerciseView = false
    
    var body: some View {
        Text("Here you can find your own exercises!")
        
        List {
            ForEach(viewModel.customExercises) { exercise in
                NavigationLink(destination: ExerciseDetailView(viewModel: viewModel, exercise: exercise)) {
                    Text(exercise.name)
                        .font(.headline)
                }
            }
            .onDelete(perform: deleteExercise)
        }
        .navigationTitle("My exercises")
        .navigationBarItems(trailing: Button(action: {
            showAddExerciseView.toggle()
        }) {
            Image(systemName: "plus.circle.fill")
                .imageScale(.large)
        })
        .sheet(isPresented: $showAddExerciseView) {
            AddExerciseView(exerciseViewModel: viewModel)
        }
    }

    private func deleteExercise(at offsets: IndexSet) {
        for index in offsets {
            let exercise = viewModel.customExercises[index]
            viewModel.deleteExercise(id: exercise.id)
        }
    }
}
