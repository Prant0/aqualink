

class Model{
  int ?id,weight,height;
  String ?types1,types2,title;
  List<Sprite>? sprite;
  Model({this.id,this.weight,this.sprite,this.types1,this.height,this.types2,this.title});
}

class Sprite{
  String ?back_default,back_shiny,front_default,front_shiny;
  Sprite({this.back_default,this.back_shiny,this.front_default,this.front_shiny});

}