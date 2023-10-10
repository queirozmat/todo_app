class TodoModel {
  int? id;
  String? tarefa;
  String? status;
  String? dataInicio;
  String? dataTermino;
  String? observacao;

  TodoModel(
      {this.id,
      this.tarefa,
      this.status,
      this.dataInicio,
      this.dataTermino,
      this.observacao});

  TodoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tarefa = json['tarefa'];
    status = json['status'];
    dataInicio = json['dataInicio'];
    dataTermino = json['dataTermino'];
    observacao = json['observacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tarefa'] = tarefa;
    data['status'] = status;
    data['dataInicio'] = dataInicio;
    data['dataTermino'] = dataTermino;
    data['observacao'] = observacao;
    return data;
  }
}
