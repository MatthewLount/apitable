我们使用 [react-jsonschema-form](https://react-jsonschema-form.readthedocs.io/en/latest/) 构建 Form 表单，

react-jsonschema-form 允许我们使用 json 来定制表单，只需要配置好 json 即可生成表单。


### 嵌套

尽管 react-jsonschema-form 支持无限层级的表单嵌套，但是从使用上来说，层级过深时，表单的使用体验很不好，UI 上也难以展示。所以我们限制表单的层级最多为三层。


以下面的「员工入职登记表」为例。

```text
员工入职登记表 （第 0 级）
  基础信息 （第 1 级）
  更多信息（第 1 级）
    喜欢的书籍 （第 2 级） 
      书名 （第 3 级）
      喜欢的原因 （第 3 级）
```

超过此层级的表单项不予展示。

### 使用

```tsx
const schema = {
  title: "员工入职登记表",
  description: "请认证填写登记表哦",
  type: "object",
  properties: {
    basic:{
      title: '基础信息',
      type:'object',
      properties: {
        name: {
          type: "string",
          title: "姓名"
        },
        gender:{
          type: "string",
          title: "性别",
          default: "man",
          enum: ["man","woman"],
          enumNames: ["男","女"],
        },
        favBook:{
          title: "选一本的书并评分",
          type: "object",
          properties:{
            title: {
              title: '书籍名称',
              type: "string",
              default: "book1",
              enum: ["book1","book2","book3"],
              // enumNames: ["红","黄","蓝"],
            },
            reason:{
              title: '评分',
              type: 'string',
              default: "A",
              enum: ["A","B","C"],

            },
          }
        }
      }
    },
    more:{
      title: '更多信息',
      type:'object',
      properties: {
        mostLikeColor:{
          type: "string",
          title: "喜欢的颜色",
          default: "red",
          enum: ["red","yellow","blue"],
          enumNames: ["红","黄","蓝"],
        },
        hobbies: {
          type: "array",
          title: "爱好",
          uniqueItems: true,
          items:{
            type: 'string',
            enum: ["playGame","watchMovie","readBook"],
            enumNames: ["玩游戏🎮","看电影🎬","读书📖"],
          }
        },
        hasCat:{
            title: "是否养猫🐱",
            description:"你是铲屎官嘛？",
            type: "boolean",
        },
        readBooks:{
            title: "读过的书籍",
            type: "array",
            items: {
              type: "object",
              properties:{
                title: {
                  title: '书籍名称',
                  type:'string',
                },
                reason:{
                  title: '评分?',
                  type: 'number',
                },
              }
            }
        },
      }
    },
  },
};

const uiSchema = {
  basic:{
    gender:{
      "ui:widget":'toggleButtonWidget',
    },
    favBook: {
      "ui:options":  {
        inline: true,
      },
      title: {
        "ui:options":  {
          showTitle: false,
        },
      },
      reason: {
        "ui:options":  {
          showTitle: false,
        },
      }
    }
  },
  more: {
    "ui:options": {
      collapse: true,
    },
    hobbies:{
      "ui:widget": "checkboxes"
    },
    readBooks:{
        "ui:options":  {
          orderable: true,
        },
        items: {
          "ui:options":  {
            inline: true,
          }
        }
    }
  }
  
};

<div style={{width: 300}}>
  <Form  schema={schema} uiSchema={uiSchema} onSubmit={(data)=>alert(JSON.stringify(data.formData))} children={null}/> 
</div>

```

### 扩展的 UI Options 

我们面对 rjsf 进行了深度定制。下面是一些扩展的 ui:options 

| key       | interface                | note                                                                                                                |
|-----------|--------------------------|---------------------------------------------------------------------------------------------------------------------|
| help      | {text:string;url:string} | 在标题后面显示帮助 icon，点击跳转到指定 url                                                                         |
| showTitle | bool                     | 是否展示标题                                                                                                        |
| inline    | bool                     | object field 下面的多个属性是否显示在同一行                                                                         |
| layout    | [][]string               | 对 inline 更加精细的布局。同一个数组中的字段显示在同一行，eg：[['openAggregation'], ['fieldId', 'aggregationType']] |



### FAQ

#### 如何隐藏  submit 按钮

```jsx static
<Form
  // ...
  children={<div/>} // hide the submit button
/>
```
