class Profile{

  Map<String, dynamic> properties = {};

  Profile(int id, Map<String, dynamic> initProperties){
    this.properties = initProperties;
  }
  void updateEmissionDetails(){
  }
}

class Profiles{
  Set<Map<String, dynamic>> rawData = {
    {'id':0, 'firstName': 'Fariha', 'lastName':'Ibnat','email':'fibnat22@gmail.com'},
    {'id':1, 'firstName': 'Alice', 'lastName':'Smith','email':'asmith21@gmail.com'},
    {'id':2, 'firstName': 'Bob', 'lastName':'Johnson','email':'bjohnson21@gmail.com'},
    {'id':3, 'firstName': 'Charlie', 'lastName':'Williams','email':'cwilliams19@gmail.com'},
    {'id':4, 'firstName': 'David', 'lastName':'Jones','email':'djone21s@gmail.com'},
  };

  List<Profile> profiles = [];

  Profiles(){
    rawData.forEach((entry) {
      createProfile(entry['id'], entry);
    });
  }

  Profile createProfile(int id, Map<String, dynamic> properties){
    Profile profile = Profile(id, properties);
    profiles.add(profile);
    return profile;
  }

  Profile getEmployee(int userId){
    return profiles[userId];
  }

}

// void main(){
//   Profiles profiles = Profiles();
//   var name = profiles.getEmployee(0).properties['firstName'];
//   print(name);
// }
