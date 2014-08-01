RSpec.describe Skill do
  let(:training_path){ TrainingPath.create(name: "Blending In") }
  context ".all" do
    context "with no training paths in the database" do
      it "should return an empty array" do
        expect(Skill.all).to eq []
      end
    end
    context "with several training paths in the database" do
      let!(:foo){ Skill.create(name: "Foo", training_path: training_path) }
      let!(:bar){ Skill.create(name: "bar", training_path: training_path) }
      let!(:grille){ Skill.create(name: "grille", training_path: training_path) }

      it "should return all of the training paths" do
        expect(Skill.all).to eq [foo, bar, grille]
      end
    end
  end
  context ".count" do
    it "returns 0 if there are no records" do
      expect(Skill.count).to eq 0
    end
    it "returns the right number if there are records" do
      Environment.database.execute("INSERT INTO skills(name, training_path_id) VALUES('Foo', 3)")
      Environment.database.execute("INSERT INTO skills(name, training_path_id) VALUES('Bar', 3)")
      expect(Skill.count).to eq 2
    end
  end
  context ".create" do
    context "with valid data" do
      let!(:skill){ Skill.create(name: "Shuffling", description: "Like running with your feet on the ground", training_path: training_path) }
      it "should have no errors" do
        expect(skill.errors).to be_nil
      end
      it "should save the record accurately" do

  puts training_path.id
        actual = Environment.database.execute("SELECT name, description, training_path_id FROM skills")
        expected = [[ "Shuffling", "Like running with your feet on the ground", training_path.id ]]
        expect(actual).to eq expected
      end
    end
    context "without a training path" do
      let!(:skill){ Skill.create(name: "Shuffling", description: "Foo", training_path: nil) }
      it "should have an error message" do
        expect(skill.errors).to include("training path cannot be blank")
      end
      it "should not save to the database" do
        expect(Skill.count).to eq 0
      end
    end
    context "with a blank name" do
      let!(:skill){ Skill.create(name: "", description: "Foo", training_path: training_path) }
      it "should have an error message" do
        expect(skill.errors).to include("name cannot be blank")
      end
      it "should not save to the database" do
        expect(Skill.count).to eq 0
      end
    end
  end
  context ".last" do
    context "if there are no records" do
      it "should return nil" do
        expect(Skill.last).to be_nil
      end
    end
    context "if there are several records" do
      let(:skill1){ Skill.create(name: "Foo", training_path: training_path) }
      let(:skill2){ Skill.create(name: "Bar", training_path: training_path) }

      before do
        skill1
        skill2
      end

      it "should return the record that was created last, populated with name" do
        expect(Skill.last.name).to eq "Bar"
      end
      it "should return the record that was created last, populated with id" do
        expect(Skill.last.id).to eq skill2.id
      end
      it "should return the record that was created last, populated with training_path_id" do
        expect(Skill.last.training_path_id).to eq training_path.id
      end
    end
  end
  context "equality" do
    let(:training_path){ TrainingPath.create(name: "Zoo") }
    context "the exact same object" do
      it "is true" do
        a = Skill.create(name: "Baz", training_path: training_path)
        expect(a).to be == a
      end
    end
    context "the same object, as retrieved by the db" do
      it "is true" do
        a = Skill.create(name: "Grille", training_path: training_path)
        b = Skill.last
        expect(b).to be == a
      end
    end
    context "non-identical objects" do
      it "is false" do
        a = Skill.create(name: "Foo", training_path: training_path)
        b = Skill.create(name: "Bar", training_path: training_path)
        expect(a).not_to be == b
      end
    end
  end
end
