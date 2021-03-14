class RouteModel{
  final String dsp;
  final String status;
  final String name;
  final String cx;
  final String id;
  final int wave;
  final String zone;

  RouteModel({
    this.dsp,this.status,this.name, this.cx,this.id, this.wave, this.zone
  });

  factory RouteModel.fromMap(Map data)
  {
    return RouteModel(
        dsp: data['dsp'] ?? "",
        status: data['status'] ?? "",
        name: data["name"] ?? "",
        cx: data["cx"]?? "",
        id: data["id"],
        wave: data["wave"],
        zone: data["zone"]
    );
  }
  Map<String,dynamic> toJson(){
    return{
      'Dsp': this.dsp,
      'Status': this.status,
      'Name': this.name,
      'Cx': this.cx,
      'Id': this.id,
      'Wave': this.wave
    };
  }

  Map<String,dynamic> toMap(e){
    return{
      'Dsp': e["Dsp"],
      'Status': e["Status"],
      'Name': e["Name"],
      'Cx': e["Cx"],
      'Id': e["Ic"],
      'Wave': e["Wave"]
    };
  }

}