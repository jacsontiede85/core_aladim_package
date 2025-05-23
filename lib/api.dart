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

    try {
      var res = await http.post(Uri.parse(urlServer ?? 'not found'),
          body: {'connection': banco ?? 'atacado', 'token': token});
      if (res.statusCode == 200) {
        //print(sql);
        //print(res.body);
        return res.body.replaceAll("null", '""');
        //return res.body;
      } else {
        print('Erro de API');
        return "";
      }
    } catch (e) {
      print('API catch');
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

      //MUDANÇA FEITA NO UPDATE, TRATANDO O AND E OS PARENTESES -- MARCO 13/10/2023
      //TRATAR ASPA SIMPLES NO UPDATE
    } else if (sql.toString().replaceAll(' ', '').substring(0, 6).toLowerCase() == 'update') {
      try {
        sql = sql.toString().replaceAll("' where", "@ where").replaceAll("'  where", "@ where").replaceAll("'   where", "@ where");
        sql = sql.toString().replaceAll("' WHERE", "@ WHERE").replaceAll("'  WHERE", "@ where").replaceAll("'   WHERE", "@ WHERE");
        sql = sql.replaceAll("='", "= @").replaceAll("= '", "= @").replaceAll("=  '", "= @").replaceAll("=   '", "= @");
        sql = sql.replaceAll("',", "@,").replaceAll("' ,", "@,").replaceAll("'  ,", "@,").replaceAll("'   ,", "@,");
        sql = sql.replaceAll(",'", ",@").replaceAll(", '", ",@").replaceAll(",  '", ",@").replaceAll(",   '", ",@");
        sql = sql.toString().replaceAll("')", "@)").replaceAll("' )", "@ )").replaceAll("'  )", "@  )").replaceAll("'   )", "@   )");
        sql = sql.toString().replaceAll("('", "(@").replaceAll("( '", "( @").replaceAll("(  '", "(  @").replaceAll("(   '", "(   @");
        sql = sql.toString().replaceAll("'AND", "@and").replaceAll("' AND", "@and").replaceAll("'  AND", "@and").replaceAll("'   AND", "@and");
        sql = sql.toString().replaceAll("'AND", "@and").replaceAll("' AND", "@and").replaceAll("'  AND", "@and").replaceAll("'   AND", "@and");
        sql = sql.replaceAll("'", "''");
        sql = sql.replaceAll("= @", "= '").replaceAll("@,", "',").replaceAll(",@",",'").replaceAll("@)", "')").replaceAll("(@", "('").replaceAll("@and", "' AND");
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


    /*
      @author Marlon Santos
      Data: 14/11/2022
      Motivo: Rotina 3780(JAVA) para flutter (app_separacao_fracionado_winthor) - Dados do embalador 
      Ação: Mudar campos com null em datas e minutos 
      Solucao: Tratar dados null para sql com HORA MIN
      Ex.: ENTRADA => TO_CHAR(SYSDATE,'HH24')     OU  TO_CHAR(SYSDATE,'MI')
            SAIDA  => TO_CHAR(SYSDATE,nullHH24'') OU  TO_CHAR(SYSDATE,nullMI'')
    */
    var aux = sql.replaceAll("(SYSDATE,null", "(SYSDATE,'");
    if (aux != sql){
      sql = sql.replaceAll("(SYSDATE,null", "(SYSDATE,'");
      sql = sql.replaceAll("''", "'");
    }

    String s = sql.toString();
    if (s.substring(s.length - 2, s.length) == "''") sql = s.substring(0, s.length - 1);

    return sql;
  }

  Future<String> getDataReportApiJWT({required Map dados, required String url, bool? printarUrlToken}) async {
    //header
    Map<String, String> header = {
      "alg": "HS256",
      "typ": "JWT",
    };
    String header64 = base64Encode(jsonEncode(header).codeUnits);

    //payload
    var payload = dados;
    String payload64 = base64Encode(utf8.encode(jsonEncode(payload))); //utf8.encode para caracteres especiais
    //assinatura
    String secret = "tisa098*";
    Hmac hmac = Hmac(sha256, secret.codeUnits);
    Digest digest = hmac.convert("$header64.$payload64".codeUnits);
    String sign = base64Encode(digest.bytes);
    String token = "$header64.$payload64.$sign";
    
    http.Response res = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          'token': token,
        },
      ),
    );

    if(printarUrlToken ?? false){
      print('url: $url');
      print('token: $token');
    }

    if (res.statusCode == 200) {
    
      return res.body.replaceAllMapped(
        RegExp(r'\:\bnull\b\,'), 
        (match) {
          return ':"",';
        },
      );
    } else {
      return "";
    }
  }

  Future<Map<String,dynamic>> sendJsonRequest ({required Map<String, dynamic> dados, required String url}) async {
    try{
      http.Response res = await http.post(
        Uri.parse(url),
        headers: {
          
        },
        body: jsonEncode(dados)
      );
      
      if(res.statusCode == 200) return jsonDecode(res.body);
      
      throw 'Erro ao executar função sendJsonRequest - Core Aladim Package';
    }catch(e){
      return {};
    }
  }

}
