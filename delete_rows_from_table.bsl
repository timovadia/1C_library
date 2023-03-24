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

/// 1 -- определяем в тзВыборкаСделки строку-продажу, которую надо удалить
индекс = тзВыборкаСделки.Количество() - 1; 
Пока индекс >= 0 Цикл
  Если индекс <> тзВыборкаСделки.Количество() - 1 тогда
    s_Сделка_Prev = тзВыборкаСделки[индекс + 1].Сделка.Номер;
  КонецЕсли;
  Если ЗначениеЗаполнено(тзВыборкаСделки[индекс].Сделка.КлиентКонтрагента) тогда
    v_КлиентКонтрагента = тзВыборкаСделки[индекс].Сделка.КлиентКонтрагента;
    СсылкаКонтрагентКлиентБО = Справочники.КлиентыБрокера.НайтиПоРеквизиту("Лицо", v_КлиентКонтрагента);
    Если ЗначениеЗаполнено(СсылкаКонтрагентКлиентБО) тогда
      s_Сделка_Now = тзВыборкаСделки[индекс].Сделка.Номер;
      Если s_Сделка_Now = s_Сделка_Prev тогда //определяем строку-продажу, которую надо удалить

        s_Поле2_Now = тзВыборкаСделки[индекс].Поле2;
        s_Поле2_Prev = тзВыборкаСделки[индекс + 1].Поле2;

        Если тзВыборкаСделки[индекс].Сделка.ВидСделки = Перечисления.ВидыСделок.Продажа тогда
          тзВыборкаСделки[индекс].remove = True; //устанавливаем признак Удаление
          
          //проверяем YYYYY второй строки: Если YYYYY (порядковый номер строки сделки) = "00002" тогда  YYYYY = "00001" 
          v_Длина_Поле2 = СтрДлина(s_Поле2_Prev);
          v_Поле2_ЛеваяЧасть = Лев(s_Поле2_Prev, v_Длина_Поле2 - 7);
          s_КонцеваяЧасть_Поле2 = Прав(s_Поле2_Prev, 7); 
          s_КонцеваяЧастьYYYYY_Поле2 = Лев(s_КонцеваяЧасть_Поле2, 1);
          Если s_КонцеваяЧастьYYYYY_Поле2 = "2" тогда
            s_КонцеваяЧасть_Поле2 = "1" + Прав(s_КонцеваяЧасть_Поле2, 6); 
            s_Поле2_new = v_Поле2_ЛеваяЧасть + s_КонцеваяЧасть_Поле2;
            тзВыборкаСделки[индекс + 1].Поле2 = s_Поле2_new;
          КонецЕсли;
          
        Иначе
          тзВыборкаСделки[индекс + 1].remove = True;
        КонецЕсли;

      КонецЕсли;
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
