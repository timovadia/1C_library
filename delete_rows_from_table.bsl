//******************** Пример 1 ***********************
//удаляем строки из таблицы значений по критерию, чтобы остались строки:
//только с ИНН = "7750004023" и пустым ВидомДоговора

индекс = тзОстаткиОборотыВалюта_фильтр_7750004023.Количество() - 1; 
Пока индекс >= 0 Цикл
  s_ИНН = тзОстаткиОборотыВалюта_фильтр_7750004023[индекс].БанкИНН;
  s_ВидДоговора = тзОстаткиОборотыВалюта_фильтр_7750004023[индекс].ВидДоговора;
  Если s_ИНН <> "7750004023" тогда
    тзОстаткиОборотыВалюта_фильтр_7750004023.Удалить(индекс);
  ИначеЕсли s_ИНН = "7750004023" И ЗначениеЗаполнено(s_ВидДоговора) тогда
    тзОстаткиОборотыВалюта_фильтр_7750004023.Удалить(индекс);
  КонецЕсли; 
  индекс = индекс - 1;
КонецЦикла;

//******************** Пример 2 ***********************
//В тзВыборкаСделки для сделок БО-БО, т.е. таких, где с каждой стороны выступает БО-клиент (в тикете для обоих строк будет указан клиент контрагента), 
//надо выводить в отчетность не две строки (как это происходит сейчас), а одну — только по покупке.
тзВыборкаСделки.Колонки.Добавить("remove", Новый ОписаниеТипов("Булево")); 
тзВыборкаСделки.Колонки.Добавить("s_ДепоКлиентаКонтрагента");
тзВыборкаСделки.Колонки.Добавить("s_КодСтраныДепоКлиентаКонтрагента");

/// 1 -- определяем в тзВыборкаСделки строку-продажу, которую надо удалить 
/// по одной сделке в отчете две строки -- покупка и продажа
индекс = тзВыборкаСделки.Количество() - 1; 
Пока индекс >= 0 Цикл
  v_КлиентКонтрагента_Now = тзВыборкаСделки[индекс].Сделка.КлиентКонтрагента;
  Если индекс <> тзВыборкаСделки.Количество() - 1 тогда
    s_Сделка_Prev 				= тзВыборкаСделки[индекс + 1].Сделка.Номер; //предыдущая строка в обратной порядке, т.е. следующая
    v_КлиентКонтрагента_Prev 	= тзВыборкаСделки[индекс + 1].Сделка.КлиентКонтрагента;
  КонецЕсли;
  //проверяем что в тикете для обеих строк указан клиент контрагента
  Если ЗначениеЗаполнено(v_КлиентКонтрагента_Now) И ЗначениеЗаполнено(v_КлиентКонтрагента_Prev) тогда
    v_КлиентКонтрагента 		= тзВыборкаСделки[индекс].Сделка.КлиентКонтрагента; 
    СсылкаКонтрагентКлиентБО 	= Справочники.КлиентыБрокера.НайтиПоРеквизиту("Лицо", v_КлиентКонтрагента);
    Если ЗначениеЗаполнено(СсылкаКонтрагентКлиентБО) тогда
      s_Сделка_Now = тзВыборкаСделки[индекс].Сделка.Номер; 
      Если s_Сделка_Now = s_Сделка_Prev тогда //это одна и та же сделка 

        //определяем строку-продажу, которую надо удалить	
        s_Поле2_Now = тзВыборкаСделки[индекс].Поле2;
        s_Поле2_Prev = тзВыборкаСделки[индекс + 1].Поле2;

        Если тзВыборкаСделки[индекс].Сделка.ВидСделки = Перечисления.ВидыСделок.Продажа тогда

          тзВыборкаСделки[индекс].remove = True; //помечаем на удаление текущую строку

          /// проверяем YYYYY второй строки: Если YYYYY (порядковый номер строки сделки) = "00002" тогда  YYYYY = "00001" 
          v_Длина_Поле2 = СтрДлина(s_Поле2_Prev);
          v_Поле2_ЛеваяЧасть = Лев(s_Поле2_Prev, v_Длина_Поле2 - 7);
          s_КонцеваяЧасть_Поле2 = Прав(s_Поле2_Prev, 7); 
          s_КонцеваяЧастьYYYYY_Поле2 = Лев(s_КонцеваяЧасть_Поле2, 1);
          Если s_КонцеваяЧастьYYYYY_Поле2 = "2" тогда //перенумеровываем Поле2 во второй строке
            s_КонцеваяЧасть_Поле2 = "1" + Прав(s_КонцеваяЧасть_Поле2, 6); 
            s_Поле2_new = v_Поле2_ЛеваяЧасть + s_КонцеваяЧасть_Поле2;
            тзВыборкаСделки[индекс + 1].Поле2 = s_Поле2_new;
          КонецЕсли;

          //заполняем поля s_ДепоКлиентаКонтрагента, s_КодСтраныДепоКлиентаКонтрагента из строки, которая потом удалится
          //значения полей 34-35 во второй строке сделки должно быть равно значению 17-18 в первой (удаляемой) строке
          тзВыборкаСделки[индекс + 1].s_ДепоКлиентаКонтрагента  			=  тзВыборкаСделки[индекс].Поле17;
          тзВыборкаСделки[индекс + 1].s_КодСтраныДепоКлиентаКонтрагента   =  тзВыборкаСделки[индекс].Поле18;

        Иначе
          тзВыборкаСделки[индекс + 1].remove = True; //помечаем на удаление предыдущую строку

          //заполняем поля s_ДепоКлиентаКонтрагента, s_КодСтраныДепоКлиентаКонтрагента из строки, которая потом удалится
          //значения полей 34-35 во второй строке сделки должно быть равно значению 17-18 в первой (удаляемой) строке
          тзВыборкаСделки[индекс].s_ДепоКлиентаКонтрагента  			=  тзВыборкаСделки[индекс + 1].Поле17;
          тзВыборкаСделки[индекс].s_КодСтраныДепоКлиентаКонтрагента   =  тзВыборкаСделки[индекс + 1].Поле18;
        КонецЕсли;

      КонецЕсли;
    КонецЕсли;
  ИначеЕсли ЗначениеЗаполнено(v_КлиентКонтрагента_Now) тогда //для строк с клиентом контрагента заполняем s_ДепоКлиентаКонтрагента, 
                                                             //s_КодСтраныДепоКлиентаКонтрагента

    ////по одной сделке в отчете содержится две строки -- покупка и продажа
    s_Сделка_Now = тзВыборкаСделки[индекс].Сделка.Номер; 
    s_Сделка_Prev = тзВыборкаСделки[индекс + 1].Сделка.Номер; //предыдущая сделка с (индексом + 1), потому что итерация в цикле с конца
    s_Сделка_Next = тзВыборкаСделки[индекс - 1].Сделка.Номер;
    //значения полей 34-35 во второй строке сделки должно быть равно значению 17-18 в первой строке
    Если s_Сделка_Now = s_Сделка_Prev тогда //это одна и та же сделка 
      //первая строка сделки -- предыдущая с конца цикла, т.е. строка с [индексом + 1]
      тзВыборкаСделки[индекс].s_ДепоКлиентаКонтрагента 			= тзВыборкаСделки[индекс + 1].Поле17;
      тзВыборкаСделки[индекс].s_КодСтраныДепоКлиентаКонтрагента   = тзВыборкаСделки[индекс + 1].Поле18;
    КонецЕсли; 
    Если s_Сделка_Now = s_Сделка_Next тогда //это одна и та же сделка
      //первая строка сделки -- следующая с конца цикла, т.е. строка с [индексом - 1]
      тзВыборкаСделки[индекс].s_ДепоКлиентаКонтрагента 			= тзВыборкаСделки[индекс - 1].Поле17;
      тзВыборкаСделки[индекс].s_КодСтраныДепоКлиентаКонтрагента   = тзВыборкаСделки[индекс - 1].Поле18;
    КонецЕсли;
  КонецЕсли;	
  индекс = индекс - 1;
КонецЦикла;	

/// 2 -- удаляем строку-продажу с признаком remove = True 
индекс = тзВыборкаСделки.Количество() - 1; 
Пока индекс >= 0 Цикл
  Если тзВыборкаСделки[индекс].remove тогда
    тзВыборкаСделки.Удалить(индекс);
  КонецЕсли; 
  индекс = индекс - 1;
  КонецЦикла;	
  ////////////////////////////////////////////////////////////////////////////
индекс = индекс - 1;
КонецЦикла;
