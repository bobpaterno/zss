RSpec.describe "Adding skills to a training path" do
  before do
    skip
  end
  context "valid input" do
    let!(:training_path1){ TrainingPath.create(name: "Weapon Skills") }
    let!(:training_path2){ TrainingPath.create(name: "Running") }
    let!(:output){ run_zss_with_input("2", "add", "Jogging") }

    it "prints a success message" do
      expect(output).to include("Jogging has been added to the Running training path")
    end

    it "saves the correct training path to the record" do
      expect(Skill.last.training_path_id).to eq training_path2.id
    end

    it "saves the skill name" do
      expect(Skill.last.name).to eq "Jogging"
    end

  end
  context "invalid input" do
    let!(:training_path){ TrainingPath.create(name: "Running") }
    let!(:output){ run_zss_with_input("1", "add", "44") }

    it "prints an error message" do
      expect(output).to include("Skill name can't be a number")
    end

    it "doesn't create a skill" do
      expect(Skill.count).to eq 0
    end
  end
end
