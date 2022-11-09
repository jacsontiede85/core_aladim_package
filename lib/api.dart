// ignore_for_file: avoid_print, empty_catches
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ApiPackage {

  //http://meuip:porta/api/';
  Future<String> jwt({required urlServer, required String sql, String? banco}) async {
    sql = validaSql(sql);

    //header
    var header = {
      "alg": "HS256",
      "typ": "JWT",
    };
    String header64 = base64Encode(jsonEncode(header).codeUnits);

    //payload
    var payload = {
      "sql": sql,
    };
    String payload64 = base64Encode(utf8.encode(jsonEncode(payload))); //utf8.encode para caracteres especiais

    //assinatura
    String secret = "tisa098*";
    var hmac = Hmac(sha256, secret.codeUnits);
    var digest = hmac.convert("$header64.$payload64".codeUnits);
    String sign = base64Encode(digest.bytes);
    String token = "$header64.$payload64.$sign";

    var res = await http.post(Uri.parse(urlServer??'not found'), body: {'connection': banco ?? 'oracle',  'token': token});
    if (res.statusCode == 200) {
      //print(sql);
      //print(res.body);
      return res.body.replaceAll("null", '""');
      //return res.body;
    } else {
      print('Erro de API');
      return "";
    }
  }

  Future<String> sendEmail(var url) async {
    var res = await http.get(url);
    if (res.statusCode == 200) {
      return res.body;
    } else {
      print('Erro de API');
      return "";
    }
  }

  String validaSql(sql) {
    //print(sql);
    //sql = sql.toLowerCase();

    // TRATAR ASPA SIMPLES NO INSERT
    if (sql.toString().replaceAll(' ', '').substring(0, 6).toLowerCase() == 'insert') {
      try {
        // List tmp = sql.toString().split('values');
        // sql = tmp[1].toString();

        // ','	  ' ,'	  '  ,'	    '   ,'
        sql = sql.toString().replaceAll("','", "@,@").replaceAll("' ,'", "@,@").replaceAll("'  ,'", "@,@").replaceAll("'   ,'", "@,@");
        // ', '	    ',  '     ',   '	  ' , '
        sql = sql.toString().replaceAll("', '", "@,@").replaceAll("',  '", "@,@").replaceAll("',   '", "@,@").replaceAll("' , '", "@,@");
        // ' ,  '	    ' ,   '	    '  , '	    '  ,  '
        sql = sql.toString().replaceAll("' ,  '", "@,@").replaceAll("' ,   '", "@,@").replaceAll("'  , '", "@,@").replaceAll("'  ,  '", "@,@");
        // '  ,   '     '   ,   '
        sql = sql.toString().replaceAll("'  ,   '", "@,@").replaceAll("'   ,   '", "@,@");

        // ,'	  , '	  ,  '	  ,   '
        sql = sql.toString().replaceAll(",'", ",@").replaceAll(", '", ",@").replaceAll(",  '", ",@").replaceAll(",   '", ",@");

        // ',	    ' ,	      '  ,	      '   ,
        sql = sql.toString().replaceAll("',", "@,").replaceAll("' ,", "@,").replaceAll("'  ,", "@,").replaceAll("'   ,", "@,");

        // ')	    ' )	      '   )
        sql = sql.toString().replaceAll("')", "@)").replaceAll("' )", "@ )").replaceAll("'  )", "@  )").replaceAll("'   )", "@   )");

        // ('	    ( '     (   '
        sql = sql.toString().replaceAll("('", "(@").replaceAll("( '", "( @").replaceAll("(  '", "(  @").replaceAll("(   '", "(   @");

        //garante que a aspa simples será inserida
        sql = sql.replaceAll("'", "''");

        sql = sql.replaceAll("@,@", "', '").replaceAll(",@", ",'").replaceAll("@,", "',").replaceAll("@)", "')").replaceAll("(@", "('");

        sql = sql.replaceAll("''brazilian portuguese'''", "brazilian portuguese'");

        //sql = "${tmp[0]}values$sql";
      } catch (e) {}

      //TRATAR ASPA SIMPLES NO UPDATE
    } else if (sql.toString().replaceAll(' ', '').substring(0, 6).toLowerCase() == 'update') {
      try {
        sql = sql.toString().replaceAll("' where", "@ where").replaceAll("'  where", "@ where").replaceAll("'   where", "@ where");
        sql = sql.toString().replaceAll("' WHERE", "@ WHERE").replaceAll("'  WHERE", "@ where").replaceAll("'   WHERE", "@ WHERE");
        sql = sql.replaceAll("='", "= @").replaceAll("= '", "= @").replaceAll("=  '", "= @").replaceAll("=   '", "= @");
        sql = sql.replaceAll("',", "@,").replaceAll("' ,", "@,").replaceAll("'  ,", "@,").replaceAll("'   ,", "@,");
        sql = sql.replaceAll("'", "''");
        sql = sql.replaceAll("= @", "= '").replaceAll("@,", "',");
        sql = sql.toString().replaceAll("@ where", "' where");
        sql = sql.toString().replaceAll("@ WHERE", "' WHERE");
      } catch (e) {}
    }

    //tratar dados null com aspa
    sql = sql.replaceAll("'null'", "null");
    sql = sql.replaceAll("'',", "null,").replaceAll("'' ,", "null,").replaceAll("''  ,", "null,").replaceAll("''   ,", "null,");
    sql = sql.replaceAll(",'',", ",null,").replaceAll(", '',", ",null,").replaceAll(",  '',", ",null,").replaceAll(",   '',", ",null,").replaceAll(",'' ,", ",null,").replaceAll(",''  ,", ",null,").replaceAll(",''   ,", ",null,").replaceAll(", '' ,", ",null,");
    sql = sql.replaceAll(",''", ",null").replaceAll(", ''", ",null").replaceAll(",   ''", ",null");
    sql = sql.replaceAll("=''", "= null").replaceAll("= ''", "= null").replaceAll("=  ''", "= null");

    String s = sql.toString();
    if (s.substring(s.length - 2, s.length) == "''") sql = s.substring(0, s.length - 1);

    //print(sql);
    return sql;
  }

}
