import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gd_api_1485/client/BarangClient.dart';
import 'package:gd_api_1485/entity/Barang.dart';
import 'package:gd_api_1485/pages/EditBarang.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final listBarangProvider = FutureProvider<List<Barang>>((ref) async {
    return await BarangClient.fetchAll();
  });

  void onAdd(context, ref) {
    Navigator.push(
            context, MaterialPageRoute(builder: (contex) => const EditBarang()))
        .then((value) => ref.refresh(listBarangProvider));
  }

  void onDelete(id, context, ref) async {
    try {
      await BarangClient.destroy(id);
      ref.refresh(listBarangProvider);
      showSnackBar(context, "Delete Success", Colors.green);
    } catch (e) {
      showSnackBar(context, e.toString(), Colors.red);
    }
  }

  ListTile scrollViewItem(Barang barang, context, ref) => ListTile(
        title: Text(barang.nama),
        subtitle: Text(barang.deskripsi),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditBarang(
                      id: barang.id,
                    ))).then((value) => ref.refresh(listBarangProvider)),
        trailing: IconButton(
          onPressed: () => onDelete(barang.id, context, ref),
          icon: Icon(Icons.delete),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var listener = ref.watch(listBarangProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("GD API 1485"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onAdd(context, ref),
        child: Icon(Icons.add),
      ),
      body: listener.when(
          data: (barangs) => SingleChildScrollView(
                child: Column(
                    children: barangs
                        .map((barang) => scrollViewItem(barang, context, ref))
                        .toList()),
              ),
          error: (err, s) => Center(child: Text(err.toString())),
          loading: () => Center(
                child: CircularProgressIndicator(),
              )),
    );
  }
}

void showSnackBar(BuildContext context, String msg, Color bg) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: bg,
      action: SnackBarAction(
          label: 'hide', onPressed: scaffold.hideCurrentSnackBar)));
}
